import Rails from "@rails/ujs";
import { addFlashMessage } from "./flash_messages";
import { handleFormSubmit } from "./form_handlers";

document.addEventListener('turbo:load', initializeImageToTextAndGenerateQuestions);

function initializeImageToTextAndGenerateQuestions() {
  const textForm = document.getElementById('text-generation-form');
  const imageForm = document.getElementById('image-upload-form');
  const extractedTextArea = document.getElementById('extracted-text-area');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const submitAllButton = document.getElementById('submit-all-questions');
  const addQuestionButton = document.getElementById('add-question-form');
  const questionsDataField = document.getElementById('questions-data');
  const saveAllQuestionsForm = document.getElementById('save-all-questions-form');
  const quizId = document.getElementById('question-forms-container').dataset.quizId;
  const textLoadingSpinner = document.getElementById('text-loading-spinner');
  const textLoadingMessage = document.getElementById('text-loading-message');

  document.querySelectorAll('.question-form').forEach(form => handleFormSubmit(form));

  if (textForm) {
    textForm.addEventListener('ajax:beforeSend', function() {
      textLoadingSpinner.classList.remove('hidden');
      textLoadingMessage.classList.remove('hidden');
    });

    textForm.addEventListener('ajax:success', function(event) {
      textLoadingSpinner.classList.add('hidden');
      textLoadingMessage.classList.add('hidden');
      const [data, status, xhr] = event.detail;
      generatedQuestionsContainer.innerHTML = '';
      data.questions.forEach(({ question, answer }) => {
        const form = createQuestionForm(question, answer);
        generatedQuestionsContainer.appendChild(form);
        handleFormSubmit(form);
      });
      addFlashMessage('notice', data.message || (data.errors && data.errors.join(', ')));
    });

    textForm.addEventListener('ajax:error', function(event) {
      textLoadingSpinner.classList.add('hidden');
      textLoadingMessage.classList.add('hidden');
      const [data, status, xhr] = event.detail;
      console.error('Error:', data);
      addFlashMessage('alert', '質問の生成中にエラーが発生しました。');
    });
  }

  submitAllButton.addEventListener('click', function(event) {
    event.preventDefault();
    const forms = document.querySelectorAll('.question-form');
    const questions = [];

    forms.forEach(form => {
      const questionText = form.querySelector('textarea[name="question[question_text]"]').value;
      const correctAnswer = form.querySelector('input[name="question[correct_answer]"]').value;
      questions.push({ question_text: questionText, correct_answer: correctAnswer });
    });

    questionsDataField.value = JSON.stringify({ questions: questions });
    Rails.fire(saveAllQuestionsForm, 'submit');
  });

  saveAllQuestionsForm.addEventListener('ajax:success', function(event) {
    const [data, status, xhr] = event.detail;
    const forms = document.querySelectorAll('.question-form');
    if (data.success) {
      addFlashMessage('notice', data.message);
      generatedQuestionsContainer.innerHTML = '';
      forms.forEach(form => form.reset());
    } else {
      let successCount = 0;

      if (data.success_questions) {
        successCount = data.success_questions.length;
        data.success_questions.forEach(success_question => {
          const form = Array.from(forms).find(form =>
            form.querySelector('textarea[name="question[question_text]"]').value === success_question.question_text &&
            form.querySelector('input[name="question[correct_answer]"]').value === success_question.correct_answer
          );
          if (form) form.remove();
        });
      }

      if (successCount > 0) {
        addFlashMessage('notice', `${successCount}件の質問が正常に保存されました。`);
      }

      if (data.errors) {
        data.errors.forEach(failed_question => {
          const form = Array.from(forms).find(form =>
            form.querySelector('textarea[name="question[question_text]"]').value === failed_question.question_text &&
            form.querySelector('input[name="question[correct_answer]"]').value === failed_question.correct_answer
          );
          if (form) {
            const errorElement = form.querySelector('.question-new__error-messages');
            if (failed_question.errors) {
              errorElement.innerHTML = failed_question.errors.map(error => `<li>${error}</li>`).join('');
              errorElement.classList.add('visible');
            } else {
              errorElement.classList.remove('visible');
            }
          }
        });
      }
    }
  });

  saveAllQuestionsForm.addEventListener('ajax:error', function(event) {
    const [xhr, status, error] = event.detail;
    console.error('Error:', error);
    addFlashMessage('alert', '質問の保存中にエラーが発生しました。');
  });

  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm('', '');
    generatedQuestionsContainer.appendChild(form);
    handleFormSubmit(form);
  });

  function createQuestionForm(question, answer) {
    const uniqueId = Math.random().toString(36).substr(2, 9);
    const form = document.createElement('form');
    form.className = 'question-new__form--dynamic question-form';
    form.action = `/quizzes/${quizId}/questions`;
    form.method = 'POST';
    form.setAttribute('data-remote', 'true');
    form.innerHTML = `
      <div class="question-new__field form-field">
        <label for="question_text_${uniqueId}" class="form-label">質問テキスト</label>
        <textarea name="question[question_text]" id="question_text_${uniqueId}" class="form-input">${question}</textarea>
      </div>
      <div class="question-new__field form-field">
        <label for="correct_answer_${uniqueId}" class="form-label">正解</label>
        <input type="text" name="question[correct_answer]" id="correct_answer_${uniqueId}" class="form-input" value="${answer}">
      </div>
      <div class="question-new__error-messages"></div>
      <div class="question-new__actions--dynamic form-actions">
        <input type="submit" value="質問を作成" class="button button--primary">
      </div>
    `;
    return form;
  }
}

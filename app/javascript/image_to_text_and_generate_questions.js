import Rails from "@rails/ujs";
document.addEventListener('turbo:load', initializeImageToTextAndGenerateQuestions);

function initializeImageToTextAndGenerateQuestions() {
  const textForm = document.getElementById('text-generation-form');
  const imageForm = document.getElementById('image-upload-form');
  const extractedTextArea = document.getElementById('extracted-text-area');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const submitAllButton = document.getElementById('submit-all-questions');
  const addQuestionButton = document.getElementById('add-question-form');
  const messageContainer = document.getElementById('message-container');
  const questionsDataField = document.getElementById('questions-data');
  const saveAllQuestionsForm = document.getElementById('save-all-questions-form');
  const quizId = document.getElementById('question-forms-container').dataset.quizId;

  document.querySelectorAll('.question-form').forEach(form => handleFormSubmit(form));

  if (imageForm) {
    imageForm.addEventListener('ajax:success', function(event) {
      const [data, status, xhr] = event.detail;
      extractedTextArea.value = data.text;
      messageContainer.textContent = data.message || (data.errors && data.errors.join(', '));
    });

    imageForm.addEventListener('ajax:error', function(event) {
      const [data, status, xhr] = event.detail;
      console.error('Error:', data);
      messageContainer.textContent = 'テキストの抽出中にエラーが発生しました。';
    });
  }

  if (textForm) {
    textForm.addEventListener('ajax:success', function(event) {
      const [data, status, xhr] = event.detail;
      generatedQuestionsContainer.innerHTML = '';
      data.questions.forEach(({ question, answer }) => {
        const form = createQuestionForm(question, answer);
        generatedQuestionsContainer.appendChild(form);
        handleFormSubmit(form);
      });
      messageContainer.textContent = data.message || (data.errors && data.errors.join(', '));
    });

    textForm.addEventListener('ajax:error', function(event) {
      const [data, status, xhr] = event.detail;
      console.error('Error:', data);
      messageContainer.textContent = '質問の生成中にエラーが発生しました。';
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

    // 質問データをhiddenフィールドに設定
    questionsDataField.value = JSON.stringify({ questions: questions });

    // Rails UJSの機能を使ってフォームを非同期で送信
    Rails.fire(saveAllQuestionsForm, 'submit');
  });

  saveAllQuestionsForm.addEventListener('ajax:success', function(event) {
    const [data, status, xhr] = event.detail;
    const forms = document.querySelectorAll('.question-form');
    if (data.success) {
      messageContainer.textContent = data.message;
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
        messageContainer.textContent = `${successCount}件の質問が正常に保存されました。`;
      }

      if (data.errors) {
        data.errors.forEach(failed_question => {
          const form = Array.from(forms).find(form =>
            form.querySelector('textarea[name="question[question_text]"]').value === failed_question.question_text &&
            form.querySelector('input[name="question[correct_answer]"]').value === failed_question.correct_answer
          );
          if (form) {
            const errorElement = form.querySelector('.error-messages');
            errorElement.textContent = '';
            errorElement.textContent = failed_question.errors.join(', ');
          }
        });
      }
    }
  });

  saveAllQuestionsForm.addEventListener('ajax:error', function(event) {
    const [xhr, status, error] = event.detail;
    console.error('Error:', error);
    messageContainer.textContent = '質問の保存中にエラーが発生しました。';
  });

  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm('', '');
    generatedQuestionsContainer.appendChild(form);
    handleFormSubmit(form);
  });

  function handleFormSubmit(form) {
    form.addEventListener('ajax:success', function(event) {
      const [data, status, xhr] = event.detail;
      messageContainer.textContent = data.message;

      if (data.success) {
        form.remove();
      } else {
        const errorElement = form.querySelector('.error-messages');
        errorElement.textContent = data.errors.join(', ');
      }
    });

    form.addEventListener('ajax:error', function(event) {
      const [data, status, xhr] = event.detail;
      console.error('Error:', data);
      messageContainer.textContent = '質問の保存中にエラーが発生しました。';
    });
  }

  function createQuestionForm(question, answer) {
    const uniqueId = Math.random().toString(36).substr(2, 9);
    const form = document.createElement('form');
    form.className = 'question-form';
    form.action = `/quizzes/${quizId}/questions`;
    form.method = 'POST';
    form.setAttribute('data-remote', 'true');
    form.innerHTML = `
      <div class="field">
        <label for="question_text_${uniqueId}">質問テキスト</label>
        <textarea name="question[question_text]" id="question_text_${uniqueId}">${question}</textarea>
      </div>
      <div class="field">
        <label for="correct_answer_${uniqueId}">正解</label>
        <input type="text" name="question[correct_answer]" id="correct_answer_${uniqueId}" value="${answer}">
      </div>
      <div class="error-messages" style="color: red;"></div>
      <div class="actions">
        <input type="submit" value="質問を作成">
      </div>
    `;

    return form;
  }
}

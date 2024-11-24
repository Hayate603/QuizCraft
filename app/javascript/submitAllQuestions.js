import Rails from "@rails/ujs";
import { addFlashMessage } from "./flash_messages";

export function submitAllQuestions() {
  const submitAllButton = document.getElementById('submit-all-questions');
  const saveAllQuestionsForm = document.getElementById('save-all-questions-form');
  const questionsDataField = document.getElementById('questions-data');
  const generatedQuestionsContainer = document.getElementById('generated-questions');

  if (!submitAllButton || !saveAllQuestionsForm || !questionsDataField || !generatedQuestionsContainer) {
    console.error('必要なDOM要素が見つかりませんでした');
    return;
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
      processErrors(data, forms);
    }
  });

  saveAllQuestionsForm.addEventListener('ajax:error', function(event) {
    const [xhr, status, error] = event.detail;
    console.error('Error:', error);
    addFlashMessage('alert', '質問の保存中にエラーが発生しました。');
  });
}

function processErrors(data, forms) {
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

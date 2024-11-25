import { addFlashMessage } from 'flash_messages';
import { handleFormSubmit } from './handleFormSubmit';
import { createQuestionForm } from './createQuestionForm';

export function textFormHandler() {
  const textForm = document.getElementById('text-generation-form');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const textLoadingSpinner = document.getElementById('text-loading-spinner');
  const textLoadingMessage = document.getElementById('text-loading-message');
  const quizId = document.getElementById('question-forms-container')?.dataset.quizId;

  if (!textForm || !generatedQuestionsContainer || !textLoadingSpinner || !textLoadingMessage || !quizId) {
    console.error('必要なDOM要素が見つかりませんでした');
    return;
  }

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
      const form = createQuestionForm(quizId, question, answer);
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

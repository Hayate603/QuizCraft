import { addFlashMessage } from './flash_messages';
import { handleFormSubmit } from './form_handlers';
import { createQuestionForm } from './question_form';

export function handleTextFormEvents(textForm, generatedQuestionsContainer, quizId, textLoadingSpinner, textLoadingMessage) {
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

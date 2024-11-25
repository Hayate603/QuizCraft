import { addFlashMessage } from "flash_messages";

export function handleFormSubmit(form) {
  form.addEventListener('ajax:success', function(event) {
    const [data, status, xhr] = event.detail;
    addFlashMessage('notice', data.message);

    if (data.success) {
      form.remove();
    } else {
      const errorElement = form.querySelector('.question-new__error-messages');
      if (data.errors && data.errors.length > 0) {
        errorElement.innerHTML = data.errors.map(error => `<li>${error}</li>`).join('');
        errorElement.classList.add('visible');
      } else {
        errorElement.classList.remove('visible');
      }
    }
  });

  form.addEventListener('ajax:error', function(event) {
    const [data, status, xhr] = event.detail;
    console.error('Error:', data);
    addFlashMessage('alert', '質問の保存中にエラーが発生しました。');
  });
}

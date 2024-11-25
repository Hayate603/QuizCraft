import { addFlashMessage } from "flash_messages";

export function imageToText() {
    const imageForm = document.getElementById('image-upload-form');
    const extractedTextArea = document.getElementById('extracted-text-area');
    const imageLoadingSpinner = document.getElementById('image-loading-spinner');
    const imageLoadingMessage = document.getElementById('image-loading-message');

    if (imageForm) {
        imageForm.addEventListener('ajax:beforeSend', function() {
            imageLoadingSpinner.classList.remove('hidden');
            imageLoadingMessage.classList.remove('hidden');
        });

        imageForm.addEventListener('ajax:success', function(event) {
            const [data, status, xhr] = event.detail;
            extractedTextArea.value = data.text;
            addFlashMessage('notice', data.message || (data.errors && data.errors.join(', ')));
            imageLoadingSpinner.classList.add('hidden');
            imageLoadingMessage.classList.add('hidden');
        });

        imageForm.addEventListener('ajax:error', function(event) {
            const [data, status, xhr] = event.detail;
            console.error('Error:', data);
            addFlashMessage('alert', 'テキストの抽出中にエラーが発生しました。');
            imageLoadingSpinner.classList.add('hidden');
            imageLoadingMessage.classList.add('hidden');
        });
    }
}

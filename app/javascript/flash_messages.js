import Rails from "@rails/ujs";

document.addEventListener('turbo:load', displayFlashMessages);

function displayFlashMessages() {
  const flashMessages = document.querySelectorAll('.toast-message');
  flashMessages.forEach(message => {
    setTimeout(() => {
      message.classList.add('visible');
      setTimeout(() => {
        message.classList.remove('visible');
        setTimeout(() => {
          message.remove();
        }, 500);
      }, 5000);
    }, 100);
  });
}

// フラッシュメッセージをクリアする関数
export function clearFlashMessages() {
  const flashContainer = document.querySelector('.toast-container');
  if (flashContainer) {
    flashContainer.innerHTML = ''; // メッセージをすべてクリア
  }
}

export function addFlashMessage(type, message) {
  // 既存のメッセージをクリア
  clearFlashMessages();

  const flashContainer = document.querySelector('.toast-container');
  const flashMessage = document.createElement('div');
  flashMessage.className = `toast-message ${type}`;
  flashMessage.textContent = message;
  flashContainer.appendChild(flashMessage);

  // 新しいメッセージを表示
  displayFlashMessages();
}

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

export function addFlashMessage(type, message) {
  const flashContainer = document.querySelector('.toast-container');
  const flashMessage = document.createElement('div');
  flashMessage.className = `toast-message ${type}`;
  flashMessage.textContent = message;
  flashContainer.appendChild(flashMessage);
  displayFlashMessages();
}

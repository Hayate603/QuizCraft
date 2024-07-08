document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('image-upload-form');

  if (form) {
    form.addEventListener('submit', function(event) {
      event.preventDefault();
      const formData = new FormData(this);

      fetch(this.action, {
        method: 'POST',
        body: formData
      }).then(response => response.json())
        .then(data => {
          const questionsContainer = document.getElementById('generated-questions');
          questionsContainer.innerHTML = `<p>${data.text}</p>`;
        }).catch(error => {
          console.error('Error:', error);
        });
    });
  }
});


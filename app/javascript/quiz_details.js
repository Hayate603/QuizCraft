document.addEventListener('turbo:load', () => {
  const showQuestionsButton = document.getElementById('show-questions-btn');
  const questionsSection = document.getElementById('questions-section');

  if (showQuestionsButton && questionsSection) {
    showQuestionsButton.addEventListener('click', function() {
      questionsSection.style.display = 'block';
      this.style.display = 'none';
    });
  }
});

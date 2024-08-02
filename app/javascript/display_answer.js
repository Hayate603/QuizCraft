document.addEventListener('turbo:load', () => {
  const showAnswerButton = document.getElementById('show-answer-btn');
  const answerSection = document.getElementById('answer-section');

  if (showAnswerButton && answerSection) {
    showAnswerButton.addEventListener('click', function() {
      answerSection.style.display = 'block';
      this.style.display = 'none';
    });
  }
});

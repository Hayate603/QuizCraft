document.addEventListener('turbo:load', () => {
  const showQuestionsButton = document.getElementById('show-questions-btn');
  const questionsSection = document.getElementById('questions-section');

  if (showQuestionsButton && questionsSection) {
    // 質問セクションが表示されていたら、常に表示を維持する
    if (window.location.search.includes('page=') || window.location.hash.includes('questions-section')) {
      questionsSection.style.display = 'block';
      showQuestionsButton.style.display = 'none';
    } else {
      // ボタンをクリックで質問セクションを表示
      showQuestionsButton.addEventListener('click', function() {
        questionsSection.style.display = 'block';
        this.style.display = 'none';
      });
    }
  }
});

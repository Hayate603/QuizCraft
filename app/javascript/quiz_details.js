document.addEventListener('turbo:load', () => {
  const toggleQuestionsButton = document.getElementById('show-questions-btn');
  const questionsSection = document.getElementById('questions-section');

  if (toggleQuestionsButton && questionsSection) {
    // ページ遷移後も状態を維持する
    if (window.location.search.includes('page=') || window.location.hash.includes('questions-section')) {
      questionsSection.classList.add('open');
      toggleQuestionsButton.textContent = '質問を隠す';
    }

    // トグルボタンのクリックイベント
    toggleQuestionsButton.addEventListener('click', function () {
      questionsSection.classList.toggle('open');
      this.textContent = questionsSection.classList.contains('open') ? '質問を隠す' : '質問を表示';
    });
  }
});


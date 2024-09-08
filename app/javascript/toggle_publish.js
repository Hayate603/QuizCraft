import Rails from "@rails/ujs";
import { addFlashMessage } from "./flash_messages";  // フラッシュメッセージ関数のインポート

document.addEventListener("turbo:load", function() {
  document.querySelectorAll('.switch-input').forEach(function(input) {
    input.addEventListener('change', function() {
      const quizId = this.dataset.quizId;
      const form = document.querySelector(`#publish-form-${quizId}`);

      if (form) {
        console.log(`トグルスイッチが変更されました (quiz_id: ${quizId})`);

        // Rails UJSでフォームを非同期送信
        Rails.fire(form, 'submit');

        // リクエスト成功時の処理
        form.addEventListener('ajax:success', function(event) {
          const [data, status, xhr] = event.detail;
          console.log(`リクエスト成功: ${data.message}`);

          // 成功時のフラッシュメッセージを追加
          addFlashMessage('notice', data.message);
        });

        // リクエスト失敗時の処理
        form.addEventListener('ajax:error', function(event) {
          console.log('リクエストに失敗しました');
          alert('公開/非公開の切り替えに失敗しました。');

          // 失敗時のフラッシュメッセージを追加
          addFlashMessage('alert', '公開/非公開の切り替えに失敗しました。');
        });
      }
    });
  });
});

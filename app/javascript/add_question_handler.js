import { addFlashMessage } from "./flash_messages";
import { createQuestionForm } from "./question_form";
import { handleFormSubmit } from "./form_handlers";

export function handleAddQuestion(addQuestionButton, generatedQuestionsContainer, quizId) {
  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm(quizId, '', ''); // 空の質問フォームを作成
    generatedQuestionsContainer.appendChild(form); // コンテナにフォームを追加
    handleFormSubmit(form); // フォーム送信イベントを登録
  });
}

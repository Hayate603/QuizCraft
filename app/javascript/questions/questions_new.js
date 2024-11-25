import { handleFormSubmit } from "./handleFormSubmit";
import { createQuestionForm } from "./createQuestionForm";
import { textFormHandler } from "./textFormHandler";
import { submitAllQuestions } from "./submitAllQuestions";
import { imageToText } from "./image_to_text";

document.addEventListener('turbo:load', () => {

  // 画像からテキストへ
  const imageForm = document.getElementById('image-upload-form');
  if (imageForm) {
    imageToText();
  }

  // 既存の質問フォームに送信機能を追加
  const questionForms = document.querySelectorAll('.question-form');
  if (questionForms.length > 0) {
    questionForms.forEach(form => handleFormSubmit(form));
  }

  // サーバーから質問データを取得して新しいフォームを作成する処理
  const textForm = document.getElementById('text-generation-form');
  if (textForm) {
    textFormHandler();
  }

  // クリック時にすべての質問をサーバーに一括送信する
  const submitAllButton = document.getElementById('submit-all-questions');
  if (submitAllButton) {
    submitAllQuestions();
  }

  // 質問フォームを追加するボタン
  const addQuestionButton = document.getElementById('add-question-form');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const quizId = document.getElementById('question-forms-container')?.dataset.quizId;

  if (addQuestionButton && generatedQuestionsContainer && quizId) {
    addQuestionButton.addEventListener('click', function (event) {
      event.preventDefault();
      const form = createQuestionForm(quizId, '', '');
      generatedQuestionsContainer.appendChild(form);
      handleFormSubmit(form);
    });
  }
});

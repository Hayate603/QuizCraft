import { handleFormSubmit } from "handleFormSubmit";
import { createQuestionForm } from "createQuestionForm";
import { textFormHandler } from "textFormHandler";
import { submitAllQuestions } from "submitAllQuestions";

document.addEventListener('turbo:load', initializeImageToTextAndGenerateQuestions);

function initializeImageToTextAndGenerateQuestions() {
  const textForm = document.getElementById('text-generation-form');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const addQuestionButton = document.getElementById('add-question-form');
  const quizId = document.getElementById('question-forms-container').dataset.quizId;

  document.querySelectorAll('.question-form').forEach(form => handleFormSubmit(form));

  if (textForm) {
    textFormHandler();
  }

  submitAllQuestions();

  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm(quizId, '', '');
    generatedQuestionsContainer.appendChild(form);
    handleFormSubmit(form);
  });
}

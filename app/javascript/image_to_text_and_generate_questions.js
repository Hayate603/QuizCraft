import { handleFormSubmit } from "./form_handlers";
import { createQuestionForm } from "./question_form";
import { handleTextFormEvents } from "./text_form_handler";
import { handleQuestionSubmission } from "./submit_handler";

document.addEventListener('turbo:load', initializeImageToTextAndGenerateQuestions);

function initializeImageToTextAndGenerateQuestions() {
  const textForm = document.getElementById('text-generation-form');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const addQuestionButton = document.getElementById('add-question-form');
  const quizId = document.getElementById('question-forms-container').dataset.quizId;

  document.querySelectorAll('.question-form').forEach(form => handleFormSubmit(form));

  if (textForm) {
    handleTextFormEvents();
  }

  handleQuestionSubmission();

  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm(quizId, '', '');
    generatedQuestionsContainer.appendChild(form);
    handleFormSubmit(form);
  });
}

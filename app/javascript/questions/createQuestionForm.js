export function createQuestionForm(quizId, question = '', answer = '') {
  const uniqueId = Math.random().toString(36).substr(2, 9);
  const form = document.createElement('form');
  form.className = 'question-new__form--dynamic question-form';
  form.action = `/quizzes/${quizId}/questions`;
  form.method = 'POST';
  form.setAttribute('data-remote', 'true');
  form.innerHTML = `
    <div class="question-new__field form-field">
      <label for="question_text_${uniqueId}" class="form-label">質問テキスト</label>
      <textarea name="question[question_text]" id="question_text_${uniqueId}" class="form-input">${question}</textarea>
    </div>
    <div class="question-new__field form-field">
      <label for="correct_answer_${uniqueId}" class="form-label">正解</label>
      <input type="text" name="question[correct_answer]" id="correct_answer_${uniqueId}" class="form-input" value="${answer}">
    </div>
    <div class="question-new__error-messages"></div>
    <div class="question-new__actions--dynamic form-actions">
      <input type="submit" value="質問を作成" class="button button--primary">
    </div>
  `;
  return form;
}

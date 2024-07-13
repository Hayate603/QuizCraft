document.addEventListener('DOMContentLoaded', () => {
  const textForm = document.getElementById('text-generation-form');
  const imageForm = document.getElementById('image-upload-form');
  const extractedTextArea = document.getElementById('extracted-text-area');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const submitAllButton = document.getElementById('submit-all-questions');
  const addQuestionButton = document.getElementById('add-question-form');
  const messageContainer = document.getElementById('message-container');

  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const quizId = document.getElementById('question-forms-container').dataset.quizId;

  document.querySelectorAll('.question-form').forEach(form => handleFormSubmit(form));

  if (imageForm) {
    imageForm.addEventListener('submit', function(event) {
      event.preventDefault();
      const submitButton = this.querySelector('input[type="submit"]');
      submitButton.disabled = true;  // ボタンを無効化
      const formData = new FormData(this);

      fetch(this.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': csrfToken
        }
      }).then(response => response.json())
        .then(data => {
          extractedTextArea.value = data.text;
          messageContainer.textContent = data.message || (data.errors && data.errors.join(', '));
          submitButton.disabled = false;
        }).catch(error => {
          console.error('Error:', error);
          messageContainer.textContent = 'テキストの抽出中にエラーが発生しました。';
          submitButton.disabled = false;
        });
    });
  }

  if (textForm) {
    textForm.addEventListener('submit', function(event) {
      event.preventDefault();
      const submitButton = this.querySelector('input[type="submit"]');
      submitButton.disabled = true;
      const formData = new FormData(this);

      fetch(this.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': csrfToken
        }
      }).then(response => response.json())
        .then(data => {
          generatedQuestionsContainer.innerHTML = '';
          data.questions.forEach(({ question, answer }) => {
            const form = createQuestionForm(question, answer);
            generatedQuestionsContainer.appendChild(form);
            handleFormSubmit(form);
          });
          messageContainer.textContent = data.message || (data.errors && data.errors.join(', '));
          submitButton.disabled = false;
        }).catch(error => {
          console.error('Error:', error);
          messageContainer.textContent = '質問の生成中にエラーが発生しました。';
          submitButton.disabled = false;
        });
    });
  }

  submitAllButton.addEventListener('click', function(event) {
    event.preventDefault();
    const forms = document.querySelectorAll('.question-form');
    const questions = [];

    forms.forEach(form => {
      const questionText = form.querySelector('textarea[name="question[question_text]"]').value;
      const correctAnswer = form.querySelector('input[name="question[correct_answer]"]').value;
      questions.push({ question_text: questionText, correct_answer: correctAnswer });
    });

    fetch(`/quizzes/${quizId}/questions/save_all_questions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ questions: questions })
    }).then(response => response.json())
      .then(data => {
        if (data.success) {
          messageContainer.textContent = data.message;
          generatedQuestionsContainer.innerHTML = '';
          document.querySelectorAll('.question-form').forEach(form => form.reset());
        } else {
          let successCount = 0;

          if (data.success_questions) {
            successCount = data.success_questions.length;
            data.success_questions.forEach(success_question => {
              const form = Array.from(forms).find(form =>
                form.querySelector('textarea[name="question[question_text]"]').value === success_question.question_text &&
                form.querySelector('input[name="question[correct_answer]"]').value === success_question.correct_answer
              );
              if (form) form.remove();
            });
          }

          if (successCount > 0) {
            messageContainer.textContent = `${successCount}件の質問が正常に保存されました。`;
          }

          if (data.errors) {
            data.errors.forEach(failed_question => {
              const form = Array.from(forms).find(form =>
                form.querySelector('textarea[name="question[question_text]"]').value === failed_question.question_text &&
                form.querySelector('input[name="question[correct_answer]"]').value === failed_question.correct_answer
              );
              if (form) {
                const errorElement = form.querySelector('.error-messages');
                errorElement.textContent = ''; // 以前のエラーメッセージをクリア
                errorElement.textContent = failed_question.errors.join(', ');
              }
            });
          }
        }
      }).catch(error => {
        console.error('Error:', error);
        messageContainer.textContent = '質問の保存中にエラーが発生しました。';
      });
  });

  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm('', '');
    generatedQuestionsContainer.appendChild(form);
    handleFormSubmit(form);
  });

  function handleFormSubmit(form) {
    form.addEventListener('submit', function(event) {
      event.preventDefault();
      const submitButton = this.querySelector('input[type="submit"]');
      submitButton.disabled = true;
      const individualFormData = new FormData(this);

      fetch(this.action, {
        method: 'POST',
        body: individualFormData,
        headers: {
          'X-CSRF-Token': csrfToken
        }
      }).then(response => response.json())
        .then(data => {
          messageContainer.textContent = '';

          if (data.success) {
            this.remove();
            messageContainer.textContent = data.message;
          } else {
            const errorElement = form.querySelector('.error-messages');
            errorElement.textContent = ''; // 以前のエラーメッセージをクリア
            if (data.errors) {
              errorElement.textContent = data.errors.join(', ');
            } else {
              messageContainer.textContent = '質問の保存中にエラーが発生しました。';
            }
          }
          submitButton.disabled = false;
        }).catch(error => {
          console.error('Error:', error);
          messageContainer.textContent = '質問の保存中にエラーが発生しました。';
          submitButton.disabled = false;
        });
    });
  }

  function createQuestionForm(question, answer) {
    const uniqueId = Math.random().toString(36).substr(2, 9);
    const form = document.createElement('form');
    form.className = 'question-form';
    form.action = `/quizzes/${quizId}/questions`;
    form.method = 'POST';
    form.innerHTML = `
      <div class="field">
        <label for="question_text_${uniqueId}">質問テキスト</label>
        <textarea name="question[question_text]" id="question_text_${uniqueId}">${question}</textarea>
      </div>
      <div class="field">
        <label for="correct_answer_${uniqueId}">正解</label>
        <input type="text" name="question[correct_answer]" id="correct_answer_${uniqueId}" value="${answer}">
      </div>
      <div class="error-messages" style="color: red;"></div>
      <div class="actions">
        <input type="submit" value="質問を作成">
      </div>
    `;

    return form;
  }
});

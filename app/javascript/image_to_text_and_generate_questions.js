document.addEventListener('DOMContentLoaded', () => {
  const textForm = document.getElementById('text-generation-form');
  const imageForm = document.getElementById('image-upload-form');
  const extractedTextArea = document.getElementById('extracted-text-area');
  const generatedQuestionsContainer = document.getElementById('generated-questions');
  const submitAllButton = document.getElementById('submit-all-questions');
  const addQuestionButton = document.getElementById('add-question-form');
  const initialQuestionForm = document.getElementById('initial-question-form');

  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const quizId = document.getElementById('question-forms-container').dataset.quizId;

  if (initialQuestionForm) {
    initialQuestionForm.addEventListener('submit', function(event) {
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
          if (data.success) {
            this.reset();
            submitButton.disabled = false;
          } else {
            alert('Failed to save the question');
            submitButton.disabled = false;
          }
        }).catch(error => {
          console.error('Error:', error);
          submitButton.disabled = false;
        });
    });
  }

  if (imageForm) {
    imageForm.addEventListener('submit', function(event) {
      event.preventDefault();
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
        }).catch(error => {
          console.error('Error:', error);
        });
    });
  }

  if (textForm) {
    textForm.addEventListener('submit', function(event) {
      event.preventDefault();
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
          });
        }).catch(error => {
          console.error('Error:', error);
        });
    });
  }

  submitAllButton.addEventListener('click', function(event) {
    event.preventDefault();
    const forms = document.querySelectorAll('.question-form');
    const questions = [];

    const initialQuestionText = initialQuestionForm.querySelector('textarea[name="question[question_text]"]').value;
    const initialCorrectAnswer = initialQuestionForm.querySelector('input[name="question[correct_answer]"]').value;
    if (initialQuestionText && initialCorrectAnswer) {
      questions.push({ question_text: initialQuestionText, correct_answer: initialCorrectAnswer });
    }

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
          generatedQuestionsContainer.innerHTML = '';
          initialQuestionForm.reset();
        } else {
          alert('Failed to save some questions');
        }
      }).catch(error => {
        console.error('Error:', error);
      });
  });

  addQuestionButton.addEventListener('click', function(event) {
    event.preventDefault();
    const form = createQuestionForm('', '');
    generatedQuestionsContainer.appendChild(form);
  });

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
      <div class="actions">
        <input type="submit" value="質問を作成">
      </div>
    `;

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
          if (data.success) {
            this.remove();
          } else {
            alert('Failed to save the question');
            submitButton.disabled = false;
          }
        }).catch(error => {
          console.error('Error:', error);
          submitButton.disabled = false;
        });
    });

    return form;
  }
});


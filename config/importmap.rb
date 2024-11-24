# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "flash_messages", to: "flash_messages.js", preload: true
pin "hamburger_menu", to: "hamburger_menu.js", preload: true
pin "display_answer", to: "display_answer.js", preload: true
pin "quiz_details", to: "quiz_details.js", preload: true
pin "toggle_publish", to: "toggle_publish.js", preload: true
pin "image_to_text", to: "image_to_text.js", preload: true
pin "handleFormSubmit", to: "handleFormSubmit.js", preload: true
pin "createQuestionForm", to: "createQuestionForm.js", preload: true
pin "textFormHandler", to: "textFormHandler.js", preload: true
pin "submitAllQuestions", to: "submitAllQuestions.js", preload: true
pin "image_to_text_and_generate_questions", to: "image_to_text_and_generate_questions.js", preload: true

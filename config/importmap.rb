# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "image_to_text_and_generate_questions", to: "image_to_text_and_generate_questions.js", preload: true
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js", preload: true
pin "flash_messages", to: "flash_messages.js", preload: true
pin "hamburger_menu", to: "hamburger_menu.js", preload: true
pin "display_answer", to: "display_answer.js", preload: true
pin "quiz_details", to: "quiz_details.js", preload: true

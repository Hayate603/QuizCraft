// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
import "controllers"
import Rails from "@rails/ujs"

Rails.start();
Turbo.start();

import "flash_messages"
import "hamburger_menu"
import "display_answer"
import "quiz_details"
import "toggle_publish"
import "questions_new"

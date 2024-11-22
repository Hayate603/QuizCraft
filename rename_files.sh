#!/bin/bash

# ファイル名の変更リスト
file_renames=(
  "app/assets/stylesheets/pages/confirmations.scss app/assets/stylesheets/pages/devise_confirmations_new.scss"
  "app/assets/stylesheets/pages/passwords-edit.scss app/assets/stylesheets/pages/devise_passwords_edit.scss"
  "app/assets/stylesheets/pages/passwords.scss app/assets/stylesheets/pages/devise_passwords_new.scss"
  "app/assets/stylesheets/pages/account_edit.scss app/assets/stylesheets/pages/devise_registrations_edit.scss"
  "app/assets/stylesheets/pages/registration.scss app/assets/stylesheets/pages/devise_registrations_new.scss"
  "app/assets/stylesheets/pages/login.scss app/assets/stylesheets/pages/devise_sessions_new.scss"
  "app/assets/stylesheets/pages/unlocks_new.scss app/assets/stylesheets/pages/devise_unlocks_new.scss"
  "app/assets/stylesheets/pages/favorite_quizzes.scss app/assets/stylesheets/pages/favorite_quizzes_index.scss"
  "app/assets/stylesheets/pages/my_quizzes.scss app/assets/stylesheets/pages/my_quizzes_index.scss"
  "app/assets/stylesheets/pages/question_edit.scss app/assets/stylesheets/pages/questions_edit.scss"
  "app/assets/stylesheets/pages/question_new.scss app/assets/stylesheets/pages/questions_new.scss"
  "app/assets/stylesheets/pages/quiz_edit.scss app/assets/stylesheets/pages/quizzes_edit.scss"
  "app/assets/stylesheets/pages/quizzes.scss app/assets/stylesheets/pages/quizzes_index.scss"
  "app/assets/stylesheets/pages/quiz_new.scss app/assets/stylesheets/pages/quizzes_new.scss"
  "app/assets/stylesheets/pages/results.scss app/assets/stylesheets/pages/quizzes_results.scss"
  "app/assets/stylesheets/pages/quiz-details.scss app/assets/stylesheets/pages/quizzes_show.scss"
  "app/assets/stylesheets/pages/quiz_take.scss app/assets/stylesheets/pages/quizzes_take.scss"
)

# ファイル名を変更
for rename_pair in "${file_renames[@]}"; do
  old_path=$(echo $rename_pair | cut -d' ' -f1)
  new_path=$(echo $rename_pair | cut -d' ' -f2)

  if [[ -f "$old_path" ]]; then
    mv "$old_path" "$new_path"
    echo "Renamed: $old_path -> $new_path"
  else
    echo "File not found: $old_path"
  fi
done

echo "All renaming tasks are completed."

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'users/:id/edit', to: 'users/registrations#edit', as: 'edit_user'
    patch 'users', to: 'users/registrations#update', as: 'update_user_registration'
    delete 'users/:id', to: 'users/registrations#destroy', as: 'user'
  end

  root 'quizzes#index'

  resources :quizzes do
    member do
      get 'take'
      get 'results'
      get 'start'
      get 'resume'
    end
    resource :favorite_quiz, only: [:create, :destroy]
    resources :questions, only: %i[new create show edit update destroy] do
      collection do
        post 'generate_from_image'
        post 'generate_questions_from_text'
        post 'save_all_questions'
      end
    end
    resources :quiz_sessions, only: [:create, :update] do
      resources :questions, only: [] do
        resources :user_answers, only: [:create]
      end
    end
  end

  resources :users, only: [] do
    resources :favorite_quizzes, only: [:index]
    get 'my_quizzes', to: 'my_quizzes#index', as: 'my_quizzes'
  end
end

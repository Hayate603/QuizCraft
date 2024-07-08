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
      get 'take', to: 'quizzes#take'
      get 'results', to: 'quizzes#results', as: 'results'
      get 'start', to: 'quizzes#start', as: 'start'
      get 'resume', to: 'quizzes#resume', as: 'resume'
    end
    resource :favorite_quiz, only: [:create, :destroy]
    resources :questions, only: %i[new create show edit update destroy] do
      resources :user_answers, only: [:create]
      collection do
        post 'generate_from_image', to: 'questions#generate_from_image'
      end
    end
    resources :quiz_sessions, only: [:create, :update]
  end

  resources :users do
    resources :favorite_quizzes, only: [:index]
    get 'my_quizzes', to: 'my_quizzes#index', as: 'my_quizzes'
  end
end

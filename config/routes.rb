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
    resources :questions, only: %i[new create]
  end

  resources :questions, only: %i[show edit update destroy]
end

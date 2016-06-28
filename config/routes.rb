Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  require "sidekiq/web"
  authenticate :user, ->u{u.supervisor?} do
    mount Sidekiq::Web => "/sidekiq"
  end

  root "static_pages#home"

  get "home" => "static_pages#home"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"

  namespace :supervisor do
    root "static_pages#home"
    resources :courses
    resources :courses, only: :show do
      resource :add_user_courses, only: [:edit, :update]
    end
    resources :course_subjects, only: [:edit, :update]
    resources :user_courses, only: :destroy
    resources :users
    resources :subjects
  end
  
  resources :user_courses, only: [:index, :show]
  resources :courses, only: [:index]
  resources :trainee_subjects, only: [:show, :update]

  resources :users, only: [:show]
  resources :relationships, only: [:create, :destroy, :show]
  resources :users, only: [:index] do 
    resources :relationships, only: [:index]
  end
end

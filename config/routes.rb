SnowSchoolers::Application.routes.draw do
  resources :instructors

  resources :beta_users

  root to: "lessons#new"

  resources :lesson_times

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    post "users/:id/verify", :to => "users/registrations#verify_instructor", :as => "verify_instructor"
    post "users/:id/revoke", :to => "users/registrations#revoke_instructor", :as => "revoke_instructor"
  end

  resources :lessons
  put   'lessons/:id/set_instructor'      => 'lessons#set_instructor',      as: :set_instructor
  put   'lessons/:id/remove_instructor'   => 'lessons#remove_instructor',   as: :remove_instructor
  patch 'lessons/:id/confirm_lesson_time' => 'lessons#confirm_lesson_time', as: :confirm_lesson_time
  get   'lessons/:id/complete'            => 'lessons#complete',            as: :complete_lesson
end

SnowSchoolers::Application.routes.draw do
  resources :transactions do
    member do
      post :charge_lesson
    end
  end

  resources :locations
  resources :charges

  # root to: "lessons#new"
  root to: "welcome#index"
  resources :instructors do
    member do
        post :verify
        post :revoke
      end
  end

  resources :beta_users


  resources :lesson_times

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: "users/omniauth_callbacks" }

  resources :lessons
  put   'lessons/:id/set_instructor'      => 'lessons#set_instructor',      as: :set_instructor
  put   'lessons/:id/remove_instructor'   => 'lessons#remove_instructor',   as: :remove_instructor
  put   'lessons/:id/mark_lesson_complete'   => 'lessons#mark_lesson_complete',   as: :mark_lesson_complete
  patch 'lessons/:id/confirm_lesson_time' => 'lessons#confirm_lesson_time', as: :confirm_lesson_time
  get   'lessons/:id/complete'            => 'lessons#complete',            as: :complete_lesson
end

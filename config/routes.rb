Rails.application.routes.draw do
  # namespace :public do
    # get 'users/show'
    # get 'users/edit'
    # get 'users/index'
    # get 'users/update'
    # get 'users/confirm'
    # get 'users/withdraw'
  # end
  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  
  
  #管理者側
  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update] do
      resources :comments, only: [:index, :destroy]
    end
  end
  
  #会員側
  scope module: :public do
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :recipes do
    resources :comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :favorites
    end
  end
  get 'users/:id/confirm' => 'users#confirm', as: 'user_confirm'
  patch 'users/:id/withdraw' => 'users#withdraw', as: 'user_withdraw'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

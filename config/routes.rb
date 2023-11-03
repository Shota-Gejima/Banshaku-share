Rails.application.routes.draw do
  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  #管理者側
  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update] do
      resources :comments, only: [:index, :destroy]
    end
    resources :tugs, only: [:index, :create, :edit, :update]
  end
  
  #会員側
  scope module: :public do
  root to: 'homes#top'
  get 'about' => 'homes#about'
  resources :recipe
  resources :users, only: [:index, :show, :edit, :update]
  get 'users/confirm' => 'users#confirm'
  patch 'users/withdraw' => 'users#withdraw'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end

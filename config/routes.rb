Rails.application.routes.draw do
  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"}
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'}
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
    delete "users/guest_sign_out", to: "users/sessions#guest_sign_out"
  end
  #管理者側
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
  end
  #会員側
  scope module: :public do
    root to: 'homes#top'
    get 'confirm' => 'homes#confirm'
    get 'about' => 'homes#about'
    get '/recipe/search', to: "recipes#search"
    resources :recipes do
      resources :comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end
    get '/users/search', to: 'users#search', as: 'user_search'
    get 'users/:id/confirm' => 'users#confirm', as: 'user_confirm'
    patch 'users/:id/withdraw' => 'users#withdraw', as: 'user_withdraw'
    resources :users, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      member do
        get :favorites
        get :follows
        get :followers
      end
    end
  end
end
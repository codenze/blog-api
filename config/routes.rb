Rails.application.routes.draw do

  resources :users, only: [] do
    resources :comments, only: [:index], controller: 'comments', action: 'user_comments'
    resources :posts, only: [:index], controller: 'posts', action: 'user_posts'
    resources :likes, only: [:index], controller: 'likes', action: 'user_likes'
    resources :reports, only: [:index], controller: 'reports', action: 'user_reports'
  end

  resources :posts, only: [] do
    resources :comments, only: [:index], controller: 'comments', action: 'post_comments'
    resources :likes, only: [:index], controller: 'likes', action: 'post_likes'
    resources :reports, only: [:index], controller: 'reports', action: 'post_reports'
  end

  resources :comments, only: [] do
    resources :likes, only: [:index], controller: 'likes', action: 'comment_likes'
    resources :reports, only: [:index], controller: 'reports', action: 'comment_reports'
  end

  resources :posts
  resources :comments
  resources :reports
  resources :likes


  resources :sessions, only: [:create]
  resources :registrations, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  get :users, to: "posts#userindex"
  get 'users/:id', to: "posts#usershow"
  patch '/users/:id', to: "posts#userupdate"
  patch '/reports/:id', to: "reports#update"
  get :comments, to: "comments#index_comments"
  root to: "static#home"
end

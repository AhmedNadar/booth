Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users

  resources :posts do
    member do
      get 'like', to: 'posts#upvote'
      get 'dislike', to: 'posts#downvote'
    end
    resources :comments
  end
end

GraphQL::Auth::Engine.routes.draw do
  devise_for :users, skip: :all
end
Arlo::Application.routes.draw do

  scope '/api/service/v1', defaults: {format: :json} do
    devise_for :users

    # devise_scope :user do
    #   match 'users/current_user', to: 'sessions#show_current_user', via: :get, as: 'current_user'
    # end
  end

  namespace :api, defaults: {format: :json} do
    namespace :service do
      namespace :v1 do

        match '/account/current', to: 'accounts#current', via: :get
        resources :accounts

        resources :questions
        match '/question/count', to: 'questions#count', via: :get

        resources :questions do
          resources :answers, only: [:create]
          resources :comments, only: [:index, :create]
        end

        resources :answers, only: [:update, :destroy] do
          resources :comments, only: [:index, :create]
        end

        resources :comments, only: [:update, :destroy]

        resources :tags, only: [:index, :create, :update, :destroy]
        match '/tag/autocomplete', to: 'tags#autocomplete', via: :get

        resources :groups, only: [:index, :show, :update, :create, :destroy]

        # resources :categories, only: [:index, :show, :update, :create, :destroy]
        #
        # match '/groups/:id/add_member', to: 'groups#add_members', via: :put, as: 'add_members'
        # match '/groups/:id/remove_member', to: 'groups#remove_members', via: :put, as: 'remove_members'
        #
        # match '/accounts/:id/add_group', to: 'accounts#add_groups', via: :put, as: 'add_groups'
        # match '/accounts/:id/remove_group', to: 'accounts#remove_groups', via: :put, as: 'remove_groups'

      end
    end
  end

  match 'angular/*path', to: "angular#show", via: [:get]
  root "angular#index"
end

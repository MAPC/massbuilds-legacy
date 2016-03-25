require 'api_version'

Rails.application.routes.draw do

  mount_ember_app :searchapp, to: 'developments/search',
    controller: 'developments', action: 'search'

  namespace :api, constraints: { subdomain: 'api' }, path: '' do
    api_version(APIVersion.new(version: 1, default: true).params) do
      jsonapi_resources :developments,  only: [:index, :show]
      jsonapi_resources :searches,      only: [:index, :show, :create]
      jsonapi_resources :subscriptions, only: [:create, :destroy]
      jsonapi_resources :organizations, only: [:index, :show]
      jsonapi_resources :development_team_memberships
    end
  end

  resources :developments, only: [:index, :show, :edit, :update] do
    # collection do
    #   get 'search', to: 'developments#search'
    #   get 'search/*ui', to: 'developments#search'
    # end
    resources :claims, only: [:new, :create]
    resources :flags,  only: [:new, :create]
    resources :edits,  only: [:index, :show] do
      post :approve, on: :member
      post :decline, on: :member
      get  :pending, on: :collection
    end
  end

  resources :searches, only: [:show], defaults: { format: :pdf }

  resources :organizations, only: [:index, :show, :edit, :create, :update, :new, :join] do
    post :join, to: 'memberships#join', on: :member
  end

  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do
    get    'signup',  to: 'devise/registrations#new'
    get    'signin',  to: 'devise/sessions#new'
    post   'signin',  to: 'devise/sessions#create'
    delete 'signout', to: 'devise/sessions#destroy'
  end

  resources :users, only: [:show] do
    resources :memberships, only: [:deactivate, :activate] do
      put :deactivate
      post :activate
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'developments#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

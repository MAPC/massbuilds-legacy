require 'api_version'
require 'subdomain_constraint'

Rails.application.routes.draw do

  mount_ember_app :searchapp, to: 'developments/:id/edit/',
    controller: 'developments',
    action:     'edit',
    as:         :edit_development

  mount_ember_app :searchapp, to: 'developments/new',
    controller: 'developments',
    action:     'new',
    as:         :new_development

  namespace :api, constraints: SubdomainConstraint.new(/^api/), path: '' do
    get 'searches/limits', to: 'searches#limits'
    api_version(APIVersion.new(version: 1, default: true).params) do
      jsonapi_resources :developments,  except: [:destroy]
      jsonapi_resources :searches,      only: [:index, :show, :create, :destroy]
      jsonapi_resources :subscriptions, only: [:create, :destroy]
      jsonapi_resources :organizations, only: [:index, :show]
      jsonapi_resources :development_team_memberships
      jsonapi_resources :searchables, only: [:show]
    end
  end

  get 'developments/map',  to: 'developments#index', rest: '/map',  ember_app: :searchapp
  get 'developments/table', to: 'developments#index', rest: '/table', ember_app: :searchapp

  resources :developments, only: [:show] do
    get :image, on: :member
    get :export, on: :collection
    resources :claims, only: [:new, :create]
    resources :flags,  only: [:new, :create] do
      post :close, on: :member
    end
    resources :edits,  only: [:index, :show] do
      post :approve, on: :member
      post :decline, on: :member
      get  :pending, on: :collection
    end
  end

  mount_ember_app :searchapp, to: 'developments',
    controller: 'developments',
    action:     'index',
    as:         :developments

  resources :searches, only: [:show], defaults: { format: :pdf }

  resources :organizations, except: [:destroy] do
    post :join,  to: 'memberships#join',       on: :member
    post :leave, to: 'memberships#deactivate', on: :member
    get  :admin, to: 'memberships#admin',      on: :member
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

  resources :memberships do
    member do
      post :approve
      post :activate, to: 'memberships#approve'
      put  :decline
      post :promote
      put  :deactivate
    end
  end

  # get 'home/index', to: 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'high_voltage/pages#show', id: 'about'

end

require 'api_version'
require 'constraint'

Rails.application.routes.draw do

  mount_ember_app :searchapp, to: 'developments/new',
    controller: 'developments',
    action:     'new',
    as:         :new_development

  namespace :api, constraints: Constraint.new(/^api/), path: '' do
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

  get 'developments/map',
    to:        'developments#index',
    rest:      '/map',
    ember_app: :searchapp

  get 'developments/table',
    to:        'developments#index',
    rest:      '/table',
    ember_app: :searchapp

  resources :developments, only: [:show, :edit, :update] do
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
    put  :leave, to: 'memberships#deactivate', on: :member
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
    get :dashboard, on: :member
    resources :memberships, only: [:deactivate, :activate] do
      put :deactivate
      put :activate
    end
  end

  resources :memberships do
    member do
      put :approve
      put :activate, to: 'memberships#approve'
      put :decline
      put :promote
      put :deactivate
    end
  end

  # Custom routes for High Voltage
  #   See: https://github.com/thoughtbot/high_voltage#override
  get "/pages/*id" => 'pages#show', as: :page, format: false
  get '/upgrade' => 'pages#show', id: 'upgrade', as: :upgrade
  get '/robots.txt' => 'pages#robots'

  root to: 'pages#show', id: 'home'

  # get 'home/index', to: 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end

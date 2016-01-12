class SearchesController < ApplicationController
  before_action :save_user_search, only: [:index]

  def index
    @search = DevelopmentSearch.new(params)
    @developments = @search.result
  end

  def show
    search = Search.find(params[:id])
    @search = DevelopmentSearch.new(search.query)
    @developments = search.developments.result
    
    render :index
  end

  def save_search
    @search = Search.find(params[:id])
    @search.saved = true
  end

  private
    def save_user_search
      if (current_user && params[:search])
        Search.create(query: params, user: current_user) 
      end
    end
end

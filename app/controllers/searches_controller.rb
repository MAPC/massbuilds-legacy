class SearchesController < ApplicationController
  # TODO: Consider -> before_action :authenticate_user!, only: [:create]

  def index
    @searches = Search.all
  end

  def show
    @search = Search.find params[:id]
  end

  def new
    @search = Search.new
  end

  def create
    @search = Search.create!(
      query: search_params[:q],
      user:  current_user )
  end

  private

    def search_params
      params.require(:search).permit(:commsf)
    end

end

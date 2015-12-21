class DevelopmentsController < ApplicationController
  def index
    @developments = Development.all
  end

  def show
    @development = DevelopmentPresenter.new(
      Development.find(params[:id])
    )
  end
end

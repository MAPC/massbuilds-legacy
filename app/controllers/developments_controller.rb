class DevelopmentsController < ApplicationController
  def index
    @developments = Development.all
  end

  def show
    @development = Development.find params[:id]
  end
end

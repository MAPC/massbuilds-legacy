class DevelopmentsController < ApplicationController
  before_action :load_record, only: [:show]

  def index
    @developments = Development.all
  end

  def show
  end

  def edit
    @development = ProposedEdit.new( Development.find(params[:id]) )
  end

  private

    def load_record
      @development = DevelopmentPresenter.new(
        Development.find(params[:id])
      )
    end
end

class DevelopmentsController < ApplicationController
  before_action :load_record, only: [:show]
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :load_proposal,      only: [:edit, :update]

  def index
    @developments = Development.all
  end

  def show
  end

  def edit
  end

  def update
    @development.assign_attributes(params[:development])
    if @development.save
      flash[:success] = """
        Thank you! Your proposed changes have been accepted and will
        be reviewed by a moderator.
      """
      redirect_to @development
    else
      flash[:danger] = """
        Would you take another look? There appear to be some errors
        with your submission.
      """
      redirect_to :edit
    end
  end

  private

    def load_record
      @development = DevelopmentPresenter.new(
        Development.find(params[:id])
      )
    end

    def load_proposal
      @development = ProposedEdit.new(
        Development.find(params[:id]),
        current_user: current_user.id
      )
    end

    def development_params
      params.require(:development).permit(:name)
    end
end

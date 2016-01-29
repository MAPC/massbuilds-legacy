class DevelopmentsController < ApplicationController
  before_action :load_record, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:edit, :update]
  after_action  :log_search, only: [:index]

  def index
    # Falls back to Development.all
    @developments = Development.periscope(search_params)
  end

  def show
  end

  def edit
  end

  def update
    # Initialize the form, since we're capturing changes through
    # the form and not acting on the development itself.
    form = DevelopmentForm.new(current_user)
    if form.submit(@development.id, edit_development_params)
      flash[:partial] = { path: "developments/proposed_success" }
      redirect_to @development
    else
      flash[:partial] = { path: "developments/proposed_error" }
      redirect_to edit_development_path(@development)
    end
  end

  private

    def load_record
      @development = DevelopmentPresenter.new(
        Development.find(params[:id])
      )
    end

    def development_params
      params.require(:development).permit(:name)
    end

    def edit_development_params
      params.require(:development).permit(
        :name, :total_cost, :rdv, :address, :city, :state, :zip_code,
        :status
      )
    end

    def search_params
      params.fetch(:q) { Hash.new }
    end

    # TODO test that empty queries don't log
    def log_search
      if search_params.keys.any?
        Search.create!( query: search_params,
          user: current_user || User.null )
      end
    end
end

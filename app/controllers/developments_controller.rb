class DevelopmentsController < ApplicationController

  layout 'search', except: [:show]

  before_action :load_record, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:edit, :update]

  def index
    @limits = Development.ranged_column_bounds.to_json
  end

  def new
  end

  def show
    if @development.out_of_date?
      flash.now[:partial] = { path: 'developments/out_of_date' }
    end
  end

  def edit
  end

  def update
    # Initialize the form, since we're capturing changes through
    # the form and not acting on the development itself.
    form = DevelopmentForm.new(devise_current_user)
    if form.submit(@development.id, edit_development_params)
      flash[:partial] = { path: 'developments/proposed_success' }
      redirect_to @development
    else
      flash[:partial] = { path: 'developments/proposed_error' }
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
    params.require(:development).permit(:name, :total_cost, :rdv,
      :address, :city, :state, :zip_code, :status)
  end

  def search_params
    params.fetch(:q) { Hash.new }
  end

end

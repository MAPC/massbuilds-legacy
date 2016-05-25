class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :load_presented_record, only: [:show, :edit]

  def index
    @organizations = Organization.order(:name).page params[:page]
  end

  def new
    @organization = Organization.new
  end

  def show
  end

  def edit
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(org_params)
      flash[:success] = 'Organization updated!'
      redirect_to @organization
    else
      render 'edit'
    end
  end

  def create
    @organization = Organization.new(org_params)
    @organization.creator = devise_current_user

    if @organization.save
      flash[:success] = 'Organization successfully created.'
      redirect_to @organization
    else
      flash[:danger] = @organization.errors.full_messages
      render new_organization_path
    end
  end

  private

  def org_params
    params.require(:organization).permit(:name, :location, :email,
      :gravatar_email, :website, :short_name, :abbv)
  end

  def load_presented_record
    @organization = OrganizationPresenter.new(
      Organization.find(params[:id])
    )
  end
end

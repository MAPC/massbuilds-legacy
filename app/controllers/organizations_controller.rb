class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :new, :edit, :update]

  def index
    @organizations = Organization.all
  end

  def show
    @organization = OrganizationPresenter.new(Organization.find(params[:id]))
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = OrganizationPresenter.new(Organization.find(params[:id]))
  end

  def update
    @organization = Organization.find(params[:id])
    if @organization.update_attributes(org_params)
      redirect_to @organization
    else
      render 'edit'
    end
  end

  def create
    @current_user = current_user
    @organization = Organization.new(org_params)
    @organization.creator = @current_user

    if @organization.save
      flash[:success] = "Organization successfully created."
      redirect_to @organization
    else
      flash[:danger] = @organization.errors.full_messages
      render new_organization_path
    end
  end

  private
    def org_params
      params.require(:organization).permit(:name, :email, :location, :short_name, :website)
    end  
end

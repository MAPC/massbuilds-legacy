class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all
  end

  def show
    @organization = OrganizationPresenter.new(Organization.find(params[:id]))
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(org_params[:organization])
    if @organization.save
      redirect_to @organization
    else
      render 'new'
    end
  end

  private
    def org_params
      # should require(:creator)
      params.require(:organization).permit(:name, :email, :location, :short_name)
    end  
end

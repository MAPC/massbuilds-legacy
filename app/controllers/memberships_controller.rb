class MembershipsController < ApplicationController

  def join
    @organization = Organization.find membership_params[:organization_id]
    @membership = Membership.new
    @membership.user = current_user
    @membership.organization = @organization

    if @membership.save
      flash[:success] = "Membership request sent."
    else
      flash[:danger] = @membership.errors.full_messages
    end

    redirect_to @organization
  end

  def deactivate
    @membership = Membership.find(membership_params[:membership_id])
    @membership.deactivated
    @membership.save
    redirect_to current_user
  end

  def activate
    @membership = Membership.new
    @membership.user = current_user

    if @membership.save
      flash[:success] = "Membership request sent."
      redirect_to @membership
    else
      flash[:danger] = @membership.errors.full_messages
      render new_organization_path
    end
  end

  private
    def membership_params
      params.permit(:membership_id, :user_id, :organization_id)
    end  
end

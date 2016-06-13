class MembershipsController < ApplicationController
  before_action :authenticate_user!, only: [:join, :deactivate]

  def join
    @organization = Organization.find membership_params[:id]
    membership = @organization.memberships.new(user: devise_current_user)

    if membership.save
      flash[:success] = 'Membership request sent.'
    else
      flash[:danger] = membership.errors.full_messages
    end

    redirect_to @organization
  end

  def deactivate
    @organization = Organization.find membership_params[:id]
    membership = @organization.memberships.find_by(user: devise_current_user)
    if membership.deactivated.save
      flash[:success] = 'Membership deactivated.'
    else
      flash[:danger] = membership.errors.full_messages
    end
    redirect_to request.referrer || @organization
  end

  private

  def membership_params
    params.permit(:membership_id, :user_id, :organization_id, :id)
  end

end

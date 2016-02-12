class MembershipsController < ApplicationController
  before_action :authenticate_user!, only: [:join, :deactivate]

  def join
    @organization = Organization.find membership_params[:id]
    membership = @organization.memberships.new(user: current_user)

    if membership.save
      flash[:success] = 'Membership request sent.'
    else
      flash[:danger] = membership.errors.full_messages
    end

    redirect_to @organization
  end

  def deactivate
    membership = Membership.find(membership_params[:membership_id])
    if membership.deactivated.save
      flash[:success] = 'Membership deactivated.'
    else
      flash[:danger] = membership.errors.full_messages
    end
    redirect_to current_user
  end

  private

  def membership_params
    params.permit(:membership_id, :user_id, :organization_id, :id)
  end

end

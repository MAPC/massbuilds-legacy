class MembershipsController < ApplicationController
  before_action :authenticate_user!, only: [:join, :deactivate]

  def join
    membership = new_membership
    if membership.save
      flash[:success] = 'Membership request sent.'
    else
      flash[:danger] = membership.errors.full_messages
    end

    redirect_to membership.organization
  end

  def deactivate
    membership = membership_by_params
    if membership.deactivated.save
      flash[:success] = 'Membership deactivated.'
    else
      flash[:danger] = membership.errors.full_messages
    end
    redirect_to request.referrer || membership.organization
  end

  private

  def new_membership
    organization = Organization.find membership_params[:id]
    organization.memberships.new(user: devise_current_user)
  end

  def membership_by_params
    if membership_params[:membership_id]
      Membership.find membership_params[:membership_id]
    elsif membership_params[:id]
      Organization.find(membership_params[:id]).
        memberships.find_by(user: devise_current_user)
    end
  end

  def membership_params
    params.permit(:membership_id, :user_id, :organization_id, :id)
  end

end

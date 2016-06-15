class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_parent,  only: [:join, :admin]
  before_action :assert_admin, only: [:approve, :decline, :admin]

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

  def approve
    membership = Membership.find(params[:id])
    membership.activated
    if membership.save
      flash[:success] = "Membership approved."
    else
      flash[:error] = "Something went wrong."
    end
    redirect_to request.referrer || admin_organization_path(@organization)
  end

  def decline
    membership = Membership.find(params[:id])
    membership.declined
    if membership.save
      flash[:success] = "Membership declined."
    else
      flash[:error] = "Something went wrong."
    end
    redirect_to request.referrer || admin_organization_path(@organization)
  end

  def promote
    membership = Membership.find(params[:id])
    membership.role = :admin
    if membership.save
      flash[:success] = "Member promoted to admin."
    else
      flash[:error] = "Something went wrong."
    end
    redirect_to request.referrer || admin_organization_path(@organization)
  end

  def admin
    @memberships = @organization.memberships
  end

  private

  def load_parent
    @organization = Organization.find membership_params[:id]
  end

  def new_membership
    @organization.memberships.new(user: devise_current_user)
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

  def assert_admin
    @organization ||= Membership.find(params[:id]).organization
    unless devise_current_user.admin_of? @organization
      flash[:error] = "You are not authorized to administrate #{@organization.short_name}."
      redirect_to @organization
    end
  end

end

class FlagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_parent, only: [:new, :create, :close]
  before_action :assert_moderator, only: [:close]

  def new
    @flag = Flag.new(development: @development)
  end

  def create
    @flag = Flag.new new_flag_params
    @flag.assign_attributes(development: @development,
      flagger: devise_current_user, state: :open)
    if @flag.save
      flash[:success] = FLAG_CREATED
      redirect_to @development
    else
      flash[:error] = FLAG_NOT_CREATED
      render :new
    end
  end

  def close
    @flag = Flag.find(params[:id])
    @flag.assign_attributes(resolver: devise_current_user)
    @flag.resolved
    @flag.save!
    redirect_to @development
  end

  private

  def load_parent
    @development = Development.find params[:development_id]
  end

  def new_flag_params
    params.require(:flag).permit(:reason)
  end

  def assert_moderator
    unless devise_current_user.moderator_for? @development
      flash[:error] = "You are not a moderator for #{@development.name}."
      redirect_to @development
    end
  end

  FLAG_CREATED = "Thanks for letting us know! We received your flag
    and will address it shortly.".gsub(/\s{2,}/, ' ').freeze

  FLAG_NOT_CREATED = 'Sorry, we were unable to accept your flag.'.freeze

end

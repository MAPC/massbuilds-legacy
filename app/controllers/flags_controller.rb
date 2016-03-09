class FlagsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :load_parent, only: [:new, :create]

  def new
    @flag = Flag.new(development: @development,
                     reason: DEFAULT_REASON)
  end

  def create
    @flag = Flag.new new_flag_params
    @flag.assign_attributes(development: @development, flagger: current_user)
    if @flag.save
      flash[:success] = FLAG_CREATED
      redirect_to @development
    else
      flash[:danger] = FLAG_NOT_CREATED
      render :new
    end
  end

  def index
    @flag = Flag.all
  end

  private

  def load_parent
    @development = Development.find params[:development_id]
  end

  def new_flag_params
    params.require(:flag).permit(:reason)
  end

  FLAG_CREATED = "Thanks! We received your flag
    and will address it shortly.".gsub(/\s{2,}/, ' ').freeze

  FLAG_NOT_CREATED = 'Sorry, we were unable to accept your flag.'.freeze

  DEFAULT_REASON = "Why are you flagging this development?
    A quick explanation (23-450 characters) will
    help us address it much more quickly.".gsub(/\s{2,}/, ' ').freeze

end

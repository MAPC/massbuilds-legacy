class EditsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_parent
  before_action :assert_moderator

  before_action :load_unmoderated_record, only: [:approve, :decline]

  def pending
  end

  def approve
    if @edit.approve!
      follow_up
    else
      default_rescue_action(object)
    end
  end

  def decline
    if @edit.decline!
      follow_up
    else
      default_rescue_action(object)
    end
  end

  private

  def assert_moderator
    unless devise_current_user.moderator_for? @development.item
      flash[:error] = "You are not a moderator for #{@development.name}."
      redirect_to @development
    end
  end

  def follow_up
    partial = partial_object(@edit.state)
    if @edit.development.edits.pending.empty?
      partial[:object][:none_left] = true
    end
    flash[:partial] = partial
    redirect_to :pending_development_edits
  end

  def load_parent
    @development = DevelopmentPresenter.new(
      Development.find(params[:development_id])
    )
  end

  def load_unmoderated_record
    @edit = Edit.find(params[:id])
    if @edit.moderated?
      flash[:error] = "The edit you were trying to moderate has already been #{@edit.state}."
      redirect_to :pending_development_edits
    end
  end

  def default_rescue_action(object)
    Airbrake.notify 'Default rescue action' if defined?(Airbrake)
    flash[:partial] = claim_not_acted_upon
    redirect_to :pending_development_edits
  end

  def partial_object(action)
    {
      path: 'edits/action',
      object: {
        action: action,
        name:   @edit.editor.first_name
      }
    }
  end

  def error_partial(message)
    { path: 'unexpected_error', object: { message: message } }
  end

  def claim_not_acted_upon
    error_partial 'As a result, the edit you were trying to resolve may not be resolved.'
  end

end

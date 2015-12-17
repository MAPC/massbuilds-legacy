class EditsController < ApplicationController

  before_action :load_parent, only: [:pending]
  before_action :load_record, only: [:approve, :decline]

  def pending
  end

  def approve
    @edit.approved
    flash[:partial] = partial_object(:approved)
    redirect_to :pending_development_edits
  rescue
    default_rescue_action
  end

  def decline
    @edit.declined
    flash[:partial] = partial_object(:declined)
    redirect_to :pending_development_edits
  rescue
    default_rescue_action
  end

  private

    def load_parent
      @development = DevelopmentPresenter.new(
        Development.find(params[:development_id])
      )
    end

    def load_record
      @edit = EditPresenter.new( Edit.find params[:id] )
    end

    def default_rescue_action
      flash[:partial] = error_partial(message)
      redirect_to :pending_development_edits
    end

    def claim_not_acted_upon
      # TODO: Trigger error notices
      error_partial """
        As a result, the edit you were trying to resolve may not be resolved.
      """
    end

    def partial_object(action)
      {path: "edits/action", object: {action: action, name: @edit.editor.first_name}}
    end

    def error_partial(message)
      { path: "unexpected_error", object: { message: message } }
    end
end

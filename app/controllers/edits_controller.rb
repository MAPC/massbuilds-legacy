class EditsController < ApplicationController

  before_action :load_parent, only: [:pending]
  before_action :load_record, only: [:approve, :decline]

  def pending
  end

  def approve
    if EditApproval.new(@edit).perform!
      flash[:partial] = partial_object(:approved)
      redirect_to :pending_development_edits
    else
      default_rescue_action
    end
  end

  def decline
    if EditDecline.new(@edit).perform!
      flash[:partial] = partial_object(:declined)
      redirect_to :pending_development_edits
    else
      default_rescue_action
    end
  end

  private

    def load_parent
      @development = DevelopmentPresenter.new(
        Development.find(params[:development_id])
      )
    end

    def load_record
      @edit = EditPresenter.new( Edit.find params[:id] )
      if @edit.moderated?
        # TODO Test this.
        flash[:error] = "The edit you were trying to moderate has already been #{@edit.state}."
        redirect_to :pending_development_edits
      end
    end

    def default_rescue_action
      flash[:partial] = error_partial(message)
      redirect_to :pending_development_edits
      # TODO: Trigger error notices
    end

    def partial_object(action)
      { path: "edits/action", object:
        { action: action, name: @edit.editor.first_name }}
    end

    def error_partial(message)
      { path: "unexpected_error", object: { message: message } }
    end

    # def claim_not_acted_upon
    #   # TODO: Trigger error notices
    #   error_partial """
    #     As a result, the edit you were trying to resolve may not be resolved.
    #   """
    # end
end

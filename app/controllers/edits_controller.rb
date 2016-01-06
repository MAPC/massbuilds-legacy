class EditsController < ApplicationController

  before_action :load_parent, only: [:pending]
  before_action :load_unmoderated_record, only: [:approve, :decline]

  def pending
  end

  def approve
    moderate(EditApproval, @edit, :approved)
  end

  def decline
    moderate(EditDecline,  @edit, :declined)
  end

  private

    def moderate(moderator_class, object, partial_ref)
      if moderator_class.new(object).perform!
        flash[:partial] = partial_object(partial_ref)
        redirect_to :pending_development_edits, status: :ok
      else
        default_rescue_action(object)
      end
    end

    def load_parent
      @development = DevelopmentPresenter.new(
        Development.find(params[:development_id])
      )
    end

    def load_unmoderated_record
      @edit = EditPresenter.new( Edit.find params[:id] )
      if @edit.moderated?
        # TODO Test this.
        flash[:error] = "The edit you were trying to moderate has already been #{@edit.state}."
        redirect_to :pending_development_edits
      end
    end

    def default_rescue_action(object)
      # TODO: Trigger Airbrake error notices
      puts """
        ERROR:
          Moderatable?: #{object.moderatable?}
          Applyable?:   #{object.applyable?}
          Conflict?:    #{object.conflict?}
          Conflicts:    #{object.conflicts}
      """
      flash[:partial] = claim_not_acted_upon
      redirect_to :pending_development_edits, status: 400
    end

    def partial_object(action)
      { path: "edits/action", object:
        { action: action, name: @edit.editor.first_name }}
    end

    def error_partial(message)
      { path: "unexpected_error", object: { message: message } }
    end

    def claim_not_acted_upon
      error_partial """
        As a result, the edit you were trying to resolve may not be resolved.
      """
    end
end

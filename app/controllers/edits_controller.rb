class EditsController < ApplicationController

  before_action :load_parent, only: [:pending]
  before_action :load_record, only: [:approve, :decline]

  def pending
  end

  def approve
    @edit.approved
    redirect_to :pending_development_edits, success: claim_approved
  rescue
    default_rescue_action
  end

  def decline
    @edit.declined
    redirect_to :pending_development_edits, success: claim_declined
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
      redirect_to :pending_development_edits, danger: claim_not_acted_upon
    end

    def claim_approved
      "You approved #{@edit.editor.short_name}'s edit."
    end

    def claim_declined
      "You declined #{@edit.editor.short_name}'s edit."
    end

    def claim_not_acted_upon
      # TODO: Trigger error notices
      "We've experienced an unexpected error."
    end
end

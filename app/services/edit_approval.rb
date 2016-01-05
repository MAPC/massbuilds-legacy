class EditApproval < EditModeration

  def initialize(edit)
    super
    @application = EditApplication.new(@edit)
  end

  def perform!
    return false unless performable?
    ActiveRecord::Base.transaction do
      @edit.approved && @edit.save
      @application.perform!
    end
  end
end

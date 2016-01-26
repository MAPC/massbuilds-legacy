class EditDecline < EditModeration

  def performable?
    @edit.moderatable?
  end

  def perform!
    return false unless performable?
    @edit.declined
    @edit.save
    true
  end

end

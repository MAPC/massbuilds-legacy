class Services::Edit::Decline < Services::Edit::Moderate

  def callable?(*args)
    @edit.moderatable?
  end

  def state
    :declined
  end

  def perform(*args)
    @edit.send state
    @edit.save!
  end

end

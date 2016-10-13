class Services::Edit::Decline < Services::Edit::Moderate

  def callable?(*args)
    @edit.moderatable?
  end

  def perform(*args)
    @edit.declined
    @edit.save!
  end

end

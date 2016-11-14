class Services::Edit::Apply < Services::Edit::Moderate

  def callable?
    @edit.applyable?
  end

  def state
    :applied
  end

  def perform
    ActiveRecord::Base.transaction do
      if @development.update_attributes(@edit.assignable)
        @edit.send state
        @edit.save!
      end
    end
  end

end

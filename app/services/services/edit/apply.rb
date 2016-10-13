class Services::Edit::Apply < Services::Edit::Moderate

  def callable?
    @edit.applyable?
  end

  def perform
    ActiveRecord::Base.transaction do
      if @development.update_attributes(@edit.assignable)
        @edit.applied
        @edit.save!
      end
    end
  end

end

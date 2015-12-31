class Form
  include ActiveModel::Model
  include Virtus.model

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

    def persist!
      raise NotImplementedError, "must implement private method #persist!. Find me in #{__FILE__}"
    end
end

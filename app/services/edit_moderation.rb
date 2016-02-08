class EditModeration

  attr_reader :edit, :development, :fields

  def initialize(edit)
    raise unless edit.valid?
    @edit = edit
    @fields = edit.fields
    @development = edit.development
  end

  def performable?
    raise NotImplementedError,
      'Override the #performable? method in your service.'
  end

  def perform!
    raise NotImplementedError,
      'Override the #perform! method in your service.'
  end
end

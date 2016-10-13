class Services::Edit::Moderate

  attr_reader :edit, :development, :fields

  # In subclasses, override #initialize to do something different.
  # Call super at the end to run this default initialization.
  def initialize(edit)
    edit.validate! # Raises ActiveRecord::RecordInvalid if invalid.
    @edit        = edit
    @fields      = edit.fields
    @development = edit.development
  end

  def call(*args)
    _call(*args)
  end

  protected

  # In subclasses, override #perform to describe what the service should do.
  # Do not use #perform to run the service -- use #call instead.
  def perform(*args)
    raise NotImplementedError, %q{
      Override #perform to describe what the service should do.
      Do not use #perform to run the service -- use #call instead.
    }
  end

  def callable?(*args)
    true
  end

  private

  def _call(*args)
    perform(*args) if callable?(*args)
  end

end

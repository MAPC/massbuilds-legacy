class EditApplication

  attr_reader :edit, :fields, :development

  def initialize(edit)
    @edit = edit
    @fields = edit.fields.freeze
    @development = edit.development
  end

  def performable?
    @edit.applyable?
  end

  def perform!
    apply! if performable?
  end

  private

  def apply!
    ActiveRecord::Base.transaction do
      if @development.update_attributes(assignable_attributes)
        @edit.applied
        @edit.save
      end
      true
    end
  end

  def assignable_attributes
    Hash[@fields.map { |f| [f.name, f.to] }]
  end

end

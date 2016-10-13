# Takes in a development, converts the changes on it to Edits and FieldEdits,
# and reverts the changes on the model itself.

class Services::Edit::Extractor

  def initialize(resource, editor)
    @resource = resource
    @editor   = editor
  end

  def call
    persist_changes_as_edits!
    @resource.reload
  end

  private

  def persist_changes_as_edits!
    ActiveRecord::Base.transaction do
      edit = @resource.edits.create!(editor: @editor)
      @resource.changes.each_pair do |name, diff|
        edit.fields.create!(
          name:   name,
          change: { from: diff.first, to: diff.last }
        )
      end
    end
  end

end

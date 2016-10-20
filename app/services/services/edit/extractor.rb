# Takes in a development, converts the changes on it to Edits and FieldEdits,
# and reverts the changes on the model itself.

class Services::Edit::Extractor

  def initialize(resource, editor, log_entry='')
    @resource = resource
    @editor   = editor
    @log_entry = log_entry
  end

  def call
    persist_changes_as_edits!
    @resource.reload
    @edit
  end

  private

  def persist_changes_as_edits!
    ActiveRecord::Base.transaction do
      @edit = @resource.edits.create!(editor: @editor.item, log_entry: @log_entry)
      @resource.changes.each_pair do |name, diff|
        begin
          @edit.fields.create!(
            name:   name,
            change: {
              from: diff.first,
              to: diff.last
            }
          )
        rescue StandardError => e
          Rails.logger.error "#{e.message}"
          next
        end
      end
    end
  end

end

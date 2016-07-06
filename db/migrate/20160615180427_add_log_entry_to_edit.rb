class AddLogEntryToEdit < ActiveRecord::Migration
  def change
    add_column :edits, :log_entry, :text
  end
end

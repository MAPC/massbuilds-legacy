class AddIgnoreConflictsToEdit < ActiveRecord::Migration
  def change
    add_column :edits, :ignore_conflicts, :boolean, default: false
  end
end

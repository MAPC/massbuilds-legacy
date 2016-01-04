class AddModeratedAtToEdit < ActiveRecord::Migration
  def change
    add_column :edits, :moderated_at, :datetime
  end
end

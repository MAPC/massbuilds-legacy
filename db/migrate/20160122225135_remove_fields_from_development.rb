class RemoveFieldsFromDevelopment < ActiveRecord::Migration
  def change
    remove_column :developments, :fields
  end
end

class AddFinalBooleansToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :cancelled, :boolean, default: false
    add_column :developments, :private,   :boolean, default: false
  end
end

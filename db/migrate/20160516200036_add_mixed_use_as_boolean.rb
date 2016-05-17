class AddMixedUseAsBoolean < ActiveRecord::Migration
  def change
    add_column :developments, :mixed_use, :boolean
  end
end

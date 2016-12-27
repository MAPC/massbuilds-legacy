class AddFortybToDevelopments < ActiveRecord::Migration
  def change
    add_column :developments, :forty_b, :boolean
    add_column :developments, :residential, :boolean
    add_column :developments, :commercial, :boolean
  end
end

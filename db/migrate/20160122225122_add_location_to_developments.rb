class AddLocationToDevelopments < ActiveRecord::Migration
  def change
    add_column :developments, :latitude,  :decimal, precision: 12, scale: 9
    add_column :developments, :longitude, :decimal, precision: 12, scale: 9
  end
end

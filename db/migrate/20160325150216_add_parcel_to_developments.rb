class AddParcelToDevelopments < ActiveRecord::Migration
  def change
    add_column :developments, :parcel_id, :string, limit: 25
  end
end

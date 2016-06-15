class AddNearestTransitToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :nearest_transit, :string
  end
end

class AddOtherRateAffordableToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :other_rate, :float
    add_column :developments, :affordable, :float
  end
end

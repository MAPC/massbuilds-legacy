class AddWalkscoreToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :walkscore, :json, null: false, default: {}
  end
end

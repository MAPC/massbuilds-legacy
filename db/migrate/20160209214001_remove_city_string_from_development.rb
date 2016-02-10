class RemoveCityStringFromDevelopment < ActiveRecord::Migration
  def change
    remove_column :developments, :city, :string, limit: 46
  end
end

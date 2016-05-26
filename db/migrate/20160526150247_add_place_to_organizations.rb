class AddPlaceToOrganizations < ActiveRecord::Migration
  def change
    add_reference :organizations, :place, index: true, foreign_key: true
  end
end

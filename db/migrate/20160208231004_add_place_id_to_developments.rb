class AddPlaceIdToDevelopments < ActiveRecord::Migration
  def change
    add_reference :developments, :place, index: true, foreign_key: true
  end
end

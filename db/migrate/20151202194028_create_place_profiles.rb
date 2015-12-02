class CreatePlaceProfiles < ActiveRecord::Migration
  def change
    create_table :place_profiles do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :radius
      t.json :polygon
      t.json :response
      t.datetime :expires_at

      t.timestamps null: false
    end
  end
end

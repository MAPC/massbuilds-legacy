class AddStreetViewFieldsToDevelopment < ActiveRecord::Migration

  def change
    add_column :developments, :street_view_heading,  :integer, limit: 3
    add_column :developments, :street_view_pitch,    :integer, limit: 2
    add_column :developments, :street_view_latitude,  :decimal,
      precision: 12, scale: 9
    add_column :developments, :street_view_longitude, :decimal,
      precision: 12, scale: 9
    add_column :developments, :street_view_image, :binary, limit: 1.megabyte
  end

end

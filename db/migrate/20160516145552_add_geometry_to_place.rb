class AddGeometryToPlace < ActiveRecord::Migration
  def change
    add_column :places, :geom, :geometry, srid: 4326, geographic: true
  end
end

class AddPointToDevelopments < ActiveRecord::Migration
  def change
    add_column :developments, :point, :st_point, geographic: true, srid: 4326
  end
end

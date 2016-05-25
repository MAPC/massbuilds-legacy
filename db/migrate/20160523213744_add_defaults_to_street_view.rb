class AddDefaultsToStreetView < ActiveRecord::Migration
  def up
    change_column_default :developments, :street_view_heading, 0
    change_column_default :developments, :street_view_pitch,   35
  end

  def down
    change_column_default :developments, :street_view_heading, nil
    change_column_default :developments, :street_view_pitch,   nil
  end
end

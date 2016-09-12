class ConvertWalkscoreJSONToString < ActiveRecord::Migration
  def up
    add_column :developments, :walkscore_string, :string, null: false, default: "{}"
    # This may only work if the walkscore field serializer is disabled.
    Development.find_each do |d|
      d.update_attribute(:walkscore_string, d.read_attribute(:walkscore).to_json)
    end
    remove_column :developments, :walkscore
    rename_column :developments, :walkscore_string, :walkscore
  end

  def down
    add_column :developments, :walkscore_json, :json, null: false, default: {}
    Development.find_each do |d|
      # This may throw a bug depending how we serialize the field.
      puts "----> #{d.id} #{d.walkscore.inspect}"
      d.update_attribute(:walkscore_json, JSON.parse(d.walkscore))
    end
    remove_column :developments, :walkscore
    rename_column :developments, :walkscore_json, :walkscore
  end
end

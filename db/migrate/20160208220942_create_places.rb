class CreatePlaces < ActiveRecord::Migration

  def change
    create_table :places do |t|
      t.string :name
      t.string :type
      t.references :place, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

end

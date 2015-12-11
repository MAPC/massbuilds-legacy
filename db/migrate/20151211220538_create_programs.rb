class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :type
      t.string :name
      t.string :description
      t.string :url
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end

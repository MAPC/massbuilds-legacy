class CreateEditFields < ActiveRecord::Migration
  def change
    create_table :edit_fields do |t|
      t.belongs_to :edit, index: true, foreign_key: true
      t.string :name
      t.json :change

      t.timestamps null: false
    end
  end
end

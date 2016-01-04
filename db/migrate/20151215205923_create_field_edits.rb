class CreateFieldEdits < ActiveRecord::Migration
  def change
    create_table :field_edits do |t|
      t.belongs_to :edit, index: true, foreign_key: true
      t.string :name
      t.json :change

      t.timestamps null: false
    end
  end
end

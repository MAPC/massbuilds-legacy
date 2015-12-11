class CreateEdits < ActiveRecord::Migration
  def change
    create_table :edits do |t|
      t.integer :editor_id, index: true, foreign_key: true
      t.integer :moderator_id, index: true, foreign_key: true
      t.belongs_to :development, index: true, foreign_key: true
      t.string :state
      t.json :fields
      t.datetime :applied_at, null: true

      t.timestamps null: false
    end
  end
end

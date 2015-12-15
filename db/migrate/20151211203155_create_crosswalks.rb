class CreateCrosswalks < ActiveRecord::Migration
  def change
    create_table :crosswalks do |t|
      t.belongs_to :organization, index: true, foreign_key: true
      t.belongs_to :development, index: true, foreign_key: true
      t.string :internal_id

      t.timestamps null: false
    end
  end
end

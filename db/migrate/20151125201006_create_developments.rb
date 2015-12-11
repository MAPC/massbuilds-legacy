class CreateDevelopments < ActiveRecord::Migration
  def change
    create_table :developments do |t|
      t.integer :creator_id, index: true, foreign_key: true
      t.json :fields

      t.timestamps null: false
    end
  end
end

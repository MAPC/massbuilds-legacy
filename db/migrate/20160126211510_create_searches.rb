class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.json :query
      t.belongs_to :user, index: true, foreign_key: true
      t.boolean :saved

      t.timestamps null: false
    end
  end
end

class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.boolean :saved, default: false
      t.json :query
      t.string :search_url
      
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

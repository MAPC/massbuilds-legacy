class CreateDevelopments < ActiveRecord::Migration
  def change
    create_table :developments do |t|
      t.json :fields

      t.timestamps null: false
    end
  end
end

class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.integer :creator_id, index: true, foreign_key: true
      t.string :name
      t.string :website
      t.string :url_template
      t.string :location
      t.string :email

      t.timestamps null: false
    end
  end
end

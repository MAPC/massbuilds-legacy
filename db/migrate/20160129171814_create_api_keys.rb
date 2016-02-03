class CreateAPIKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :token, length: 32, null: false, unique: true

      t.timestamps null: false
    end
  end
end

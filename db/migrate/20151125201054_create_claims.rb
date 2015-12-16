class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.integer :claimant_id, index: true, foreign_key: true
      t.belongs_to :development, index: true, foreign_key: true
      t.integer :moderator_id, index: true, foreign_key: true
      t.string :role

      t.timestamps null: false
    end
  end
end

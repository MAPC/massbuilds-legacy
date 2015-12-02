class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.belongs_to :user,     index: true, foreign_key: true
      t.integer :verifier_id, index: true, foreign_key: true
      t.text    :reason
      t.string  :state

      t.timestamps null: false
    end
  end
end

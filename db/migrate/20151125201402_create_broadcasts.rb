class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.string :subject
      t.string :body
      t.string :scope
      t.datetime :scheduled_for
      t.string :state
      t.integer :creator_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

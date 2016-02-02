class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :subscribable, polymorphic: true, index: true
      t.datetime :last_checked_at

      t.timestamps null: false
    end
  end
end

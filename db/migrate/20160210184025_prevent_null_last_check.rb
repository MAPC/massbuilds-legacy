class PreventNullLastCheck < ActiveRecord::Migration
  def up
    change_column :users, :last_checked_subscriptions, :datetime, null: false
    execute('ALTER TABLE users ALTER COLUMN last_checked_subscriptions SET DEFAULT now()')
  end

  def down
    change_column :users, :last_checked_subscriptions, :datetime, null: true, default: nil
  end
end

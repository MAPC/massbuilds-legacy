class PreventNullLastCheck < ActiveRecord::Migration
  def change
    change_column :users, :last_checked_subscriptions, :datetime, null: false, default: Time.now
  end
end

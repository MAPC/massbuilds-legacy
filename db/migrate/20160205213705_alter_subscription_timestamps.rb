class AlterSubscriptionTimestamps < ActiveRecord::Migration
  def change
    add_column :users, :last_checked_subscriptions, :datetime
    remove_column :subscriptions, :last_checked_at
  end
end

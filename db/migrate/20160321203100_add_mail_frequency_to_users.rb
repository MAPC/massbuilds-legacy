class AddMailFrequencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_frequency, :string, limit: 8, default: :weekly
  end
end

class ChangeAttributeNameOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :hasherized_email, :hashed_email
  end
end

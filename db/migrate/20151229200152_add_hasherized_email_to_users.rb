class AddHasherizedEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hasherized_email, :string
  end
end

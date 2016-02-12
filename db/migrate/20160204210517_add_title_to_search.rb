class AddTitleToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :title, :string, limit: 140
  end
end

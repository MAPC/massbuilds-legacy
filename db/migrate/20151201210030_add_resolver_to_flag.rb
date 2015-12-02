class AddResolverToFlag < ActiveRecord::Migration
  def change
    add_column :flags, :resolver_id, :integer, index: true, foreign_key: true
  end
end

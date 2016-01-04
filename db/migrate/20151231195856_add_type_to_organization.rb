class AddTypeToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :type, :boolean
  end
end

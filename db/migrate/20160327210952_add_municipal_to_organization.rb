class AddMunicipalToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :municipal, :boolean
  end
end

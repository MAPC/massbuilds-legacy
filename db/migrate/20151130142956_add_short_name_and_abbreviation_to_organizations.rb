class AddShortNameAndAbbreviationToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :abbv, :string
    add_column :organizations, :short_name, :string
  end
end

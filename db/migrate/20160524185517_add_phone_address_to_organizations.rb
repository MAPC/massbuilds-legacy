class AddPhoneAddressToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :phone,   :string, limit: 20
    add_column :organizations, :address, :string
  end
end

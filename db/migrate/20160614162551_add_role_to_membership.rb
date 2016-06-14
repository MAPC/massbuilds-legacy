class AddRoleToMembership < ActiveRecord::Migration
  def up
    add_column :memberships, :role, :string, null: false, default: 'normal'

    # Make all organization creators admins.
    Organization.find_each do |organization|
      membership = organization.memberships.find_by user: organization.creator
      membership.update_attribute(:role, :admin) if membership
    end
  end

  def down
    remove_column :memberships, :role, :string
  end
end

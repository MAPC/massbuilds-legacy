class AddTeamMembershipCountToDevelopments < ActiveRecord::Migration
  def change
    add_column :developments, :team_membership_count, :integer
  end
end

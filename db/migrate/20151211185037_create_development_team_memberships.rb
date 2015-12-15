class CreateDevelopmentTeamMemberships < ActiveRecord::Migration
  def change
    create_table :development_team_memberships do |t|
      t.string :role
      t.belongs_to :development, index: true, foreign_key: true
      t.belongs_to :organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

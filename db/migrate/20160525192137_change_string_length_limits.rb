class ChangeStringLengthLimits < ActiveRecord::Migration
  def up
    change_column :developments, :tagline, :string, limit: nil
    change_column :developments, :desc, :text, limit: 500
  end

  def down
    change_column :developments, :tagline, :string, limit: 85
    change_column :developments, :desc, :string
  end
end

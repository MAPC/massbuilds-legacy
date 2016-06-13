class SetDefaultSearchQuery < ActiveRecord::Migration
  def up
    change_column_null    :searches, :query, false
    change_column_default :searches, :query, {}
  end

  def down
    change_column_null    :searches, :query, true
    change_column_default :searches, :query, nil
  end
end

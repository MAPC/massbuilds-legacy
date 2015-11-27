class AddReasonToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :reason, :string
    add_column :claims, :state,  :string
  end
end

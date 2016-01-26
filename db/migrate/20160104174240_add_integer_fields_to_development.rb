class AddIntegerFieldsToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :height,     :integer
    add_column :developments, :stories,    :integer
    add_column :developments, :year_compl, :integer
    add_column :developments, :prjarea,    :integer
    add_column :developments, :singfamhu,  :integer
    add_column :developments, :twnhsmmult, :integer
    add_column :developments, :lgmultifam, :integer
    add_column :developments, :tothu,      :integer
    add_column :developments, :gqpop,      :integer
    add_column :developments, :rptdemp,    :integer
    add_column :developments, :emploss,    :integer
    add_column :developments, :estemp,     :integer
    add_column :developments, :commsf,     :integer
    add_column :developments, :hotelrms,   :integer
    add_column :developments, :onsitepark, :integer
    add_column :developments, :total_cost, :integer
  end
end

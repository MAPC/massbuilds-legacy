class AddFloorAreaFieldsToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :fa_ret, :float
    add_column :developments, :fa_ofcmd, :float
    add_column :developments, :fa_indmf, :float
    add_column :developments, :fa_whs, :float
    add_column :developments, :fa_rnd, :float
    add_column :developments, :fa_edinst, :float
    add_column :developments, :fa_other, :float
    add_column :developments, :fa_hotel, :float
  end
end

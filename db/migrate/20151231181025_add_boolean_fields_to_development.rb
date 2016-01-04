class AddBooleanFieldsToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :rdv,       :boolean
    add_column :developments, :asofright, :boolean
    add_column :developments, :ovr55,     :boolean
    add_column :developments, :clusteros, :boolean
    add_column :developments, :phased,    :boolean
    add_column :developments, :stalled,   :boolean
  end
end

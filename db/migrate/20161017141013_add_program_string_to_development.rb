class AddProgramStringToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :programs, :string
  end
end

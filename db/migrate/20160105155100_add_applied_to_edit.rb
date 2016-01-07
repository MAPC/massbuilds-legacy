class AddAppliedToEdit < ActiveRecord::Migration
  def up
    add_column :edits, :applied, :boolean, default: false, null: false
    Edit.find_each do |edit|
      if edit.state == 'applied'
        edit.update_attributes(state: :approved, applied: true)
      end
    end
  end

  def down
    Edit.find_each { |edit|
      edit.update_attribute(:state, :applied) if edit.applied?
    }
    remove_column :edits, :applied, :boolean
  end
end

class AddStringFieldsToDevelopment < ActiveRecord::Migration
  def change
    add_column :developments, :name,        :string, limit: 140
    add_column :developments, :status,      :string, limit: 20
    add_column :developments, :desc,        :string
    add_column :developments, :project_url, :string, limit: 140
    add_column :developments, :mapc_notes,  :string
    add_column :developments, :tagline,     :string, limit: 85
    add_column :developments, :address,     :string, limit: 140
    add_column :developments, :city,        :string, limit: 46 # Lake Char­gogg­a­gogg...
    add_column :developments, :state,       :string, limit: 2, default: 'MA'
    add_column :developments, :zip_code,    :string, limit: 9
  end
end

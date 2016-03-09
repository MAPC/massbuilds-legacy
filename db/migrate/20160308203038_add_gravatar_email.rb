class AddGravatarEmail < ActiveRecord::Migration
  def change
    add_column :organizations, :gravatar_email, :string
    add_column :organizations, :hashed_email, :string
  end
end

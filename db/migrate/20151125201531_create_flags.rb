class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :flagger_id, index: true, foreign_key: true
      t.belongs_to :development, index: true, foreign_key: true
      t.text :reason
      t.string :state

      t.timestamps null: false
    end
  end
end

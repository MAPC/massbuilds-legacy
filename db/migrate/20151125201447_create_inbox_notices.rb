class CreateInboxNotices < ActiveRecord::Migration
  def change
    create_table :inbox_notices do |t|
      t.string :subject
      t.string :body
      t.string :state
      t.string :level

      t.timestamps null: false
    end
  end
end

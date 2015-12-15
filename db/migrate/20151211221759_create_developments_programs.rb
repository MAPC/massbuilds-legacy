class CreateDevelopmentsPrograms < ActiveRecord::Migration
  def change
    create_table :developments_programs do |t|
      t.belongs_to :development, index: true, foreign_key: true
      t.belongs_to :program, index: true, foreign_key: true
    end
  end
end

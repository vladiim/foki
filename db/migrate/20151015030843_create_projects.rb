class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.integer :program_id, null: false
      t.text :tags
      t.timestamps null: false
    end
  end
end

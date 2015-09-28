class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :title, null: false
      t.float :latest_daily_change
      t.integer :program_id
    end
  end
end

class AddDataToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :data, :json
  end
end

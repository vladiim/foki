class RemoveLatestDailyChangeFromMetric < ActiveRecord::Migration
  def change
    remove_column :metrics, :latest_daily_change, :float
  end
end

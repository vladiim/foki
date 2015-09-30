class AddFocusMetricToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :focus_metric, :json
  end
end

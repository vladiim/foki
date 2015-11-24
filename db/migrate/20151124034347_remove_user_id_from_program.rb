class RemoveUserIdFromProgram < ActiveRecord::Migration
  def change
    remove_column :programs, :user_id
  end
end

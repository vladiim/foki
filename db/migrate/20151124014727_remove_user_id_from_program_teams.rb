class RemoveUserIdFromProgramTeams < ActiveRecord::Migration
  def change
    remove_column :program_teams, :user_id
    add_column :program_teams, :from_id, :integer, null: false
    add_column :program_teams, :to_id, :integer
  end
end

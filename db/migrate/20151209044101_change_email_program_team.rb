class ChangeEmailProgramTeam < ActiveRecord::Migration
  def change
    change_column :program_teams, :email, :string, null: true
  end
end

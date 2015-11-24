class AddAcceptedToProgramTeam < ActiveRecord::Migration
  def change
    add_column :program_teams, :accepted, :datetime
  end
end

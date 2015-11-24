class CreateProgramTeam < ActiveRecord::Migration
  def change
    create_table :program_teams do |t|
      t.integer :program_id, require: true
      t.integer :user_id
      t.string :email, require: true
    end
  end
end

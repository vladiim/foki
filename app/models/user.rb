class User < ActiveRecord::Base
  has_many :program_teams, foreign_key: 'from_id', dependent: :destroy
  has_many :program_teams, foreign_key: 'to_id', dependent: :destroy
  has_many :programs, through: :program_teams

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def all_programs
    @all_programs ||= get_all_programs
  end

  def program_with_children(program_id)
    all_programs.select do |program|
      program.id == program_id.to_i
    end.first
  end

  def name
    username || email[0, email.index('@')]
  end

  private

  def get_all_programs
    program_ids = get_program_ids
    return [] if program_ids.empty?
    Program.includes(:metrics, :projects).
      where(id: program_ids)
  end

  def get_program_ids
    self_programs_teams.
      select {|pt| invite_accepted?(pt)}.
      map {|pt| pt.program_id}
  end

  def self_programs_teams
    ProgramTeam.includes(:program).
      uniq.where("from_id = ? OR to_id = ?", self.id, self.id).all
  end

  def invite_accepted?(program_team)
    program_team.to_id != self.id || program_team.accepted != nil
  end
end

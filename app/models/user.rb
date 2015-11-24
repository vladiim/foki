class User < ActiveRecord::Base
  # has_many :programs
  has_many :program_teams, foreign_key: 'from_id'
  has_many :program_teams, foreign_key: 'to_id'
  has_many :programs, through: :program_teams

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def all_programs
    @all_programs ||= get_all_programs
  end

  def program(program_id)
    programs.where(user_id: self.id).
      first
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
    ProgramTeam.includes(:program).
      uniq.
      where("from_id = ? OR to_id = ?", self.id, self.id).
      all.
      map {|pt| pt.program_id}
  end
end

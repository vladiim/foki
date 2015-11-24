class User < ActiveRecord::Base
  # has_many :programs
  has_many :program_teams, foreign_key: 'from_id'
  has_many :program_teams, foreign_key: 'to_id'
  has_many :programs, through: :program_teams

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def program(program_id)
    programs.where(user_id: self.id).
      first
  end

  def program_with_children(program_id)
    Program.includes(:metrics, :projects).
      where(user_id: self.id, id: program_id).
      first
  end

  def name
    username || email[0, email.index('@')]
  end
end

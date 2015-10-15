class User < ActiveRecord::Base
  has_many :programs

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
end

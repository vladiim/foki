class User < ActiveRecord::Base
  has_many :programs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def program_with_metrics(program_id)
    Program.includes(:metrics).
      where(user_id: self.id, id: program_id).
      first
  end
end

# itsapassword

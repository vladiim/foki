class ProgramTeam < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User', foreign_key: :from_id
  belongs_to :invitee, class_name: 'User', foreign_key: :to_id
  belongs_to :program

  validates_presence_of :program_id

  before_save :set_invitee_details

  private

  def set_invitee_details
    return invite_program_team_member unless creating_new_program?
    self.accepted = Date.today
  end

  def creating_new_program?
    self.from_id == self.to_id && self.accepted.nil?
  end

  def invite_program_team_member
    invitee    = User.where(email: self.email).first
    self.to_id = invitee.id if invitee
  end
end

class ProgramTeam < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'
  belongs_to :program

  validates_presence_of :program_id

  before_create do
    self.from_id = to_id unless self.from_id
    invitee      = User.where(email: self.email).first
    self.to_id   = invitee.id if invitee
  end
end

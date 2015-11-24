class ProgramTeam < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  belongs_to :invitee, class_name: 'User'
  belongs_to :program
end

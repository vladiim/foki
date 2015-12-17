class Invite
  attr_reader :id, :from, :title
  def initialize(team)
    @id    = team.id
    @title = Program.find(team.program_id).title
    @from  = User.find(team.from_id).name
  end

  def self.all(to_id)
    teams = program_teams(to_id)
    teams.empty? ? [] : create_invites(teams)
  end

  private

  def self.program_teams(to_id)
    ProgramTeam.includes(:inviter).
      where(to_id: to_id, accepted: nil).
      where.not(from_id: to_id).
      all
  end

  def self.create_invites(teams)
    teams.inject([]) do |invites, team|
      invites << new(team)
    end
  end
end

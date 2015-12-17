class ProgramTeamMailer < ActionMailer::Base
  def invite(program_team_id)
    team = find_program_team(program_team_id)
    BaseMandrillMailer.send_mail(team.email,
      "Program team invite from: #{team.inviter.name}",
      'program_team_invite', invite_vars(team))
  end

  private

  def invite_vars(team)
    {
      'TITLE' => team.program.title,
      'USERNAME' => team.inviter.name,
      'TOKENIZED_URL' => 'blah'
    }
  end

  def find_program_team(program_team_id)
    ProgramTeam.includes(:program, :inviter).
      find(program_team_id)
  end
end

class ProgramTeamsController < ApplicationController
  respond_to :html, :js

  def create
    @team = ProgramTeam.new(create_params)
    @team.save ? create_success : create_fail
  end

  private

  def create_success
    respond_to do |format|
      format.js {@program = Program.find(@team.program_id)}
    end
  end

  def create_params
    params.require(:program_team).permit(:email, :program_id, :from_id)
  end
end

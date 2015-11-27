class ProgramTeamsController < ApplicationController
  respond_to :html, :js

  def create
    @team    = ProgramTeam.new(create_params)
    @program = Program.find(@team.program_id)
    @team.save ? create_success : create_fail
  end

  def update
    @team = ProgramTeam.find(params[:id])
    return invite_fail unless update_params[:to_id].to_i == @team.to_id
    @team.update(update_params) ? update_success : invite_fail
  end

  def destroy
    @team = ProgramTeam.find(params[:id])
    return invite_fail unless destroy_params[:to_id].to_i == @team.to_id
    @team.destroy ? destroy_success : invite_fail
  end

  private

  def create_success
    flash[:success] = 'Team member invited'
    respond_to do |format|
      format.js {}
      format.html {redirect_to program_path(@program)}
    end
  end

  def create_fail
    flash[:danger] = 'There was an issue inviting the team member'
    render program_path(@program)
  end

  def update_success
    flash[:success] = 'Invite accepted'
    redirect_to program_path(@team.program_id)
  end

  def invite_fail
    flash[:danger] = 'There was an issue updating your invite'
    render 'programs/index'
  end

  def destroy_success
    flash[:success] = 'Invite declined'
    respond_to do |format|
      format.js {}
      format.html {redirect_to programs_path}
    end
  end

  def create_params
    params.require(:program_team).permit(:email, :program_id, :from_id)
  end

  def update_params
    params.require(:program_team).permit(:accepted, :id, :to_id)
  end

  def destroy_params
    params.require(:program_team).permit(:to_id)
  end
end

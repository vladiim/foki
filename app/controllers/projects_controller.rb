class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def create
    @program = current_user.program_with_children(project_params[:program_id])
    @project = @program.projects.build(project_params)
    @project.save ? redirect_to_program('New project created.') : render_program_index('creating the new project')
  end

  def destroy
    Project.find(destroy_params[:id]).destroy
    @program = current_user.program_with_children(destroy_params[:program_id])
    respond_to do |format|
      format.html do
        redirect_to program_path(@program)
        flash[:success] = "Project deleted."
      end
      format.js {}
    end
  end

  private

  def render_program_index(message)
    render 'program#index'
    flash[:danger] = "There was an issue #{message}."
  end

  def redirect_to_program(message)
    respond_to do |format|
      format.html do
        redirect_to program_path(@program.id)
        flash[:success] = message
      end
      format.js {}
    end
  end

  def project_params
    params.require(:project).permit(:title, :program_id, tags: [])
  end

  def destroy_params
    params.permit(:id, :program_id)
  end
end
class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @program       = Program.find(index_params[:program_id])
    @projects      = ProjectFilter.new(@program, index_params).process
    @metric_filter = index_params[:metric]
    @status_filter = index_params[:status]
    respond_to do |format|
      format.js {}
    end
  end

  def create
    @program = current_user.program_with_children(project_params[:program_id])
    @project = @program.projects.build(project_params)
    @project.save ? redirect_to_program('New project created.') : render_program_index('creating the new project')
  end

  def update
    Project.find(update_params[:id]).update(update_params)
    @program  = current_user.program_with_children(update_params[:program_id])
    @projects = @program.projects
    respond_to do |format|
      format.js {}
    end
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

  def index_params
    params.permit(:status, :metric, :program_id)
  end

  def project_params
    params.require(:project).permit(:title, :program_id, tags: [])
  end

  def update_params
    params.require(:project).permit(:id, :program_id, :title, :live)
      .merge(params.permit(:id))
  end

  def destroy_params
    params.permit(:id, :program_id)
  end
end

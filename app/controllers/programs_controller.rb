class ProgramsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_resource, except: :show
  respond_to :html, :js

  def index
    @programs = current_user.programs
  end

  def show
    @program = current_user.program_with_children(params[:id])
    set_metric_resource
    set_project_resources
  end

  def create
    @program = current_user.programs.build(program_params)
    @program.save ? redirect_to_program(@program, "New program '#{@program.title}' created.") : render_index('creating the new program')
  end

  def update
    @program = current_user.program_with_children(params[:id])
    @updater = ProgramUpdater.new(@program)
    @updater.update(program_params) ? redirect_to_program(@program, "#{@program.title} updated.") : render_index('updating the program')
  end

  def destroy
    @program_id = params[:id]
    Program.find(@program_id).destroy
    respond_to do |format|
      format.html do
        redirect_to programs_path
        flash[:success] = "Program deleted."
      end
      format.js { set_resource; @programs = current_user.programs }
    end
  end

  private

  def render_index(message)
    render 'index'
    flash[:danger] = "There was an issue #{message}."
  end

  def redirect_to_program(program, message)
    respond_to do |format|
      format.html do
        redirect_to program
        flash[:success] = message
      end
      format.js { set_resource; @programs = current_user.programs }
    end
  end

  def set_resource
    @resource_name = :program
    @resource_path = programs_path
  end

  def set_metric_resource
    @resource_name = :metric
    @resource_path = metrics_path
  end

  def set_project_resources
    @projects      = @program.projects
    @metric_filter = 'all'
    @status_filter = 'all'
  end

  def program_params
    params.require(:program).permit(:title, :focus_metric)
  end
end

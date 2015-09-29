class ProgramsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_resource, except: :show

  def index
    @programs = current_user.programs
  end

  def show
    @program = current_user.program_with_metrics(params[:id])
    @metrics = @program.metrics
    set_metric_resource
  end

  def update
    byebug
    @program = current_user.program(params[:id])
    @program.update(program_params) ? redirect_to_program(@program, "#{@program.title} updated.") : render_index('updating the program')
  end

  def create
    @program = current_user.programs.build(program_params)
    @program.save ? redirect_to_program(@program, "New program '#{@program.title}' created.") : render_index('creating the new program')
  end

  def destroy
    Program.find(params[:id]).destroy
    redirect_to action: :index
  end

  private

  def render_index(message)
    render 'index'
    flash[:danger] = "There was an issue #{message}."
  end

  def redirect_to_program(program, message)
    redirect_to program
    flash[:success] = message
  end

  def set_resource
    @resource_name = :program
    @resource_path = programs_path
  end

  def set_metric_resource
    @resource_name = :metric
    @resource_path = metrics_path
  end

  def program_params
    params[:program].permit(:title)
  end
end

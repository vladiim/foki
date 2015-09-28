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

  def create
    @program = current_user.programs.build(program_params)
    @program.save ? redirect_to_program(@program) : render_index
  end

  def destroy
    Program.find(params[:id]).destroy
    redirect_to action: :index
  end

  private

  def render_index
    render 'index'
    flash[:error] = "There was an issue creating the new program."
  end

  def redirect_to_program(program)
    redirect_to program
    flash[:success] = "New program '#{program.title}' created."
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

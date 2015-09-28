class MetricsController < ApplicationController
  def create
    @metric = Metric.new(metric_params)
    @metric.save ? redirect_to_program : render_program_index
  end

  private

  def render_index
    render 'program#index'
    flash[:error] = "There was an issue creating the new metric."
  end

  def redirect_to_program
    redirect_to program_path(params[:metric][:program_id])
    flash[:success] = "New metric created."
  end

  def metric_params
    params[:metric].permit(:title, :program_id)
  end
end

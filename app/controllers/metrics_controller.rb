class MetricsController < ApplicationController
  def create
    @metric = Metric.new(metric_params)
    @metric.save ? redirect_to_program('New metric created.') : render_program_index('creating the new metric')
  end

  def update
    file = params[:metric][:data].tempfile
    metric = MetricUpdater.new(params[:id])
    metric.save_data(file) ? redirect_to_program('Data added.') : render_index('uploading the data')
  end

  def destroy
    Metric.find(params[:id]).destroy
    redirect_to program_path(params[:page_id])
    flash[:success] = "Metric deleted."
  end

  private

  def render_index(message)
    render 'program#index'
    flash[:danger] = "There was an issue #{message}."
  end

  def redirect_to_program(message)
    redirect_to program_path(params[:metric][:program_id])
    flash[:success] = message
  end

  def metric_params
    params[:metric].permit(:title, :program_id)
  end
end

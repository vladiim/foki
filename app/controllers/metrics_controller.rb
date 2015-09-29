class MetricsController < ApplicationController
  def create
    @metric = Metric.new(metric_params)
    @metric.save ? redirect_to_program('New metric created.') : render_program_index('creating the new metric')
  end

  def update
    update     = metric_params
    file       = update.delete('data')
    data_saved = upload_data(file) if file
    metric     = Metric.find(params[:id])
    metric.update(update) ? redirect_to_program('Metric updated.') : render_index('updating the metric.')
  end

  def destroy
    Metric.find(params[:id]).destroy
    redirect_to program_path(params[:page_id])
    flash[:success] = "Metric deleted."
  end

  private

  def upload_data(file)
    metric = MetricUpdater.new(params[:id])
    metric.save_data(file.tempfile)
  end

  def render_index(message)
    render 'program#index'
    flash[:danger] = "There was an issue #{message}."
  end

  def redirect_to_program(message)
    redirect_to program_path(params[:metric][:program_id])
    flash[:success] = message
  end

  def metric_params
    params[:metric].permit(:title, :program_id, :data)
  end
end

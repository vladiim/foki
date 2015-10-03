class MetricsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def create
    set_metric_resource
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
    @metric_id = params[:id]
    @program   = Program.find(params[:program_id])
    Metric.find(@metric_id).destroy
    respond_to do |format|
      format.html do
        redirect_to program_path(@program)
        flash[:success] = "Metric deleted."
      end
      format.js { set_metric_resource }
    end
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
    program_id = params[:metric][:program_id]
    respond_to do |format|
      format.html do
        redirect_to program_path(program_id)
        flash[:success] = message
      end
      format.js { @program = Program.find(program_id) }
    end
  end

  def set_metric_resource
    @resource_name = :metric
    @resource_path = metrics_path
  end

  def metric_params
    params.require(:metric).permit(:title, :program_id, :data)
  end
end

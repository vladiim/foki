class FocusMetric
  attr_reader :program
  def initialize(program)
    @program = program
  end

  def data
    return {} if program.focus_metric.nil?
    program.focus_metric.map do |focus_metric|
      process_metric(focus_metric)
    end
  end

  private

  def process_metric(focus_metric)
    metric_data = get_metric_data(focus_metric)
    return {} if metric_data.instance_of? NullMetricData
    get_data(focus_metric, metric_data)
  end

  def get_metric_data(focus_metric)
    focus_id = focus_metric.fetch('focus_metric').to_i
    program.metrics.select { |m| m.id == focus_id }.
      first.data || NullMetricData.new
  end

  def get_data(focus_metric, metric_data)
    focus_date = focus_metric.fetch('date')
    raw_data   = metric_data.select { |m| JSON.parse(m).fetch('date') == focus_date }.first
    return {} unless raw_data
    process_data(raw_data)
  end

  def process_data(raw_data)
    data = JSON.parse(raw_data)
    { 'date' => data.fetch('date'), 'value' => data.fetch('value') }
  end
end

class NullMetricData
end

class FocusMetric
  attr_reader :program
  def initialize(program)
    @program = program
  end

  def json_data
    data.map { |d| d.to_json }
  end

  private

  def data
    return {} if program.focus_metric.nil?
    ordered_metrics = program.ordered_metrics.dup
    process_metrics(ordered_metrics).flatten
  end

  def process_metrics(ordered_metrics)
    data = []
    until ordered_metrics.empty? do
      focus_metric            = JSON.parse(ordered_metrics.shift)
      next_metric             = ordered_metrics[0] || today_metric
      to_date                 = JSON.parse(next_metric).fetch('date')
      focus_metric['to_date'] = format_date(to_date) -1
      data << process_metric(focus_metric)
    end
    data.flatten
  end

  def process_metric(focus_metric)
    metric_data = get_metric_data(focus_metric)
    return {} unless metric_data
    get_data(focus_metric, metric_data)
  end

  def get_metric_data(focus_metric)
    focus_id = focus_metric.fetch('focus_metric').to_i
    focus_metric = program.metrics.select { |m| m.id == focus_id }.first
    return {} unless focus_metric && focus_metric.data
    focus_metric.data.map { |d| JSON.parse(d) }
  end

  def get_data(focus_metric, metric_data)
    from_date = format_date(focus_metric.fetch('date'))
    to_date   = focus_metric.fetch('to_date')
    data      = filter_metric_data(metric_data, from_date, to_date)
    return {} unless data
    data
  end

  def filter_metric_data(metric_data, from_date, to_date)
    metric_data.select do |m|
      date = format_date(m.fetch('date'))
      (from_date..to_date).cover?(date)
    end
  end

  def today_metric
    today = Date.today
    {'date'=>"#{today.year}-#{today.month}-#{today.day}"}.to_json
  end

  def format_date(date)
    Date.strptime(date, '%Y-%m-%d')
  end
end

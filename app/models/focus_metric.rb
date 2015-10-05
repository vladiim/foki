class FocusMetric
  attr_reader :program
  def initialize(program)
    @program = program
  end

  def data
    return {} if program.focus_metric.nil?
    ordered_metrics = program.ordered_metrics.dup
    process_metrics(ordered_metrics).flatten
  end

  private

  def process_metrics(ordered_metrics)
    data = []
    until ordered_metrics.empty? do
      focus_metric            = ordered_metrics.shift
      next_metric             = ordered_metrics[0] || today_metric
      focus_metric['to_date'] = format_date(next_metric.fetch('date')) -1
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
    return {} unless focus_metric
    focus_metric.data
  end

  def get_data(focus_metric, metric_data)
    from_date = format_date(focus_metric.fetch('date'))
    to_date   = focus_metric.fetch('to_date')
    raw_data  = get_raw_data(metric_data,from_date, to_date)
    return {} unless raw_data
    process_data(raw_data)
  end

  def get_raw_data(metric_data,from_date, to_date)
    metric_data.select do |m|
      date = format_date(JSON.parse(m).fetch('date'))
      (from_date..to_date).cover?(date)
    end
  end

  def process_data(raw_data)
    processed_data = raw_data.map { |d| JSON.parse(d) }
    processed_data.map do |data|
      { 'date' => data.fetch('date'), 'value' => data.fetch('value') }
    end
  end

  def today_metric
    today = Date.today
    {'date'=>"#{today.year}-#{today.month}-#{today.day}"}
  end

  def format_date(date)
    Date.strptime(date, '%Y-%m-%d')
  end
end

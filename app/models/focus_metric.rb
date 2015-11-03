class FocusMetric
  attr_reader :program, :program_metrics, :metrics
  def initialize(program)
    @program         = program
    @program_metrics = program.metrics
    @metrics         = add_earliest_date(program_ordered_metrics)
  end

  def json_data
    data.map { |d| d.to_json }
  end

  private

  def program_ordered_metrics
    return {} if program.focus_metric.nil?
    program.ordered_metrics.inject([]) {|d, m| d << JSON.parse(m)}
  end

  def data
    calculate_all_change(focus_metric_data)
  end

  def add_earliest_date(metrics)
    return [] if metrics.empty?
    first_focus_metric = get_metric(metrics[0])
    return metrics unless first_focus_metric && defined?(first_focus_metric.data)
    metrics.unshift(earliest_metric(first_focus_metric)).flatten
  end

  def earliest_metric(first_focus_metric)
    earliest_date  = first_focus_metric.data.map {|data| JSON.parse(data).fetch('date')}.min
    {'focus_metric' => first_focus_metric.id, 'date' => earliest_date}
  end

  def focus_metric_data
    (1..metrics.length).each_with_index.inject([]) do |result, (next_index, focus_index)|
      focus_metric = focus_metric_with_to_date(focus_index, next_index)
      result << focus_metric_with_data(focus_metric)
      result
    end
  end

  def focus_metric_with_to_date(focus_index, next_index)
    focus_metric = metrics[focus_index]
    next_metric  = metrics[next_index] || today_metric
    to_date      = format_date(next_metric.fetch('date')) -1
    focus_metric.merge({'to_date' => to_date.to_s})
  end

  def focus_metric_with_data(focus_metric)
    metric_data = get_metric_data(focus_metric)
    return {} unless metric_data
    get_data(focus_metric, metric_data)
  end

  def get_metric_data(focus_metric)
    metric = get_metric(focus_metric)
    process_metric_data(metric)
  end

  def get_metric(focus_metric)
    focus_id = focus_metric.fetch('focus_metric')
    metric   = program_metrics.select {|m| m.id == focus_id}.first
    return {} unless metric && metric.data
    metric
  end

  def process_metric_data(focus_metric)
    return focus_metric if focus_metric == {}
    focus_metric.data.map do |d|
      JSON.parse(d).
        merge('metric' => focus_metric.title)
    end
  end

  def get_data(focus_metric, metric_data)
    from_date = format_date(focus_metric.fetch('date')) - 1
    to_date   = format_date(focus_metric.fetch('to_date'))
    data      = filter_metric_data(metric_data, from_date, to_date)
    data ? data : {}
  end

  def filter_metric_data(metric_data, from_date, to_date)
    metric_data.select do |m|
      date = format_date(m.fetch('date'))
      (from_date..to_date).cover?(date)
    end
  end

  def calculate_all_change(metric_data)
    metric_data.each.inject([]) do |result, metric_section_data|
      result << calculate_section_change(metric_section_data)
    end.flatten
  end

  def calculate_section_change(metric_data)
    metric_data.each_with_index.inject([]) do |metric, (today, index)|
      tomorrow = metric_data[index + 1]
      metric << calculate_change(today, tomorrow) if tomorrow
      metric
    end
  end

  def calculate_change(today, tomorrow)
    tom_val = tomorrow.fetch('value').to_f
    tod_val = today.fetch('value').to_f
    change  = (tom_val - tod_val) / tod_val
    tomorrow.merge('change' => change)
  end

  def format_date(date)
    Date.strptime(date.to_s, '%Y-%m-%d')
  end

  def today_metric
    today = Date.today
    {'date' => format_date("#{today.year}-#{today.month}-#{today.day}")}
  end
end

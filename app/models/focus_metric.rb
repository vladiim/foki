class FocusMetric
  attr_reader :program, :program_metrics
  def initialize(program)
    @program         = program
    @program_metrics = program.metrics
  end

  def json_data
    byebug
    data.map { |d| d.to_json }
  end

  private

  def data
    return {} if program.focus_metric.nil?
    ordered_metrics = program.ordered_metrics.dup
    # all_metrics     = add_earliest_date(ordered_metrics.dup)
    hash_metrics    = ordered_metrics.inject([]) { |metrics, metric| metrics << JSON.parse(metric) }
    all_metrics     = add_earliest_date(hash_metrics)
    # byebug
    metrics         = process_metrics(all_metrics)
    calculate_each_change(metrics)
  end

  def calculate_each_change(metrics)
    metrics.each.inject([]) do |result, metrics_section|
      result << calculate_section_change(metrics_section)
    end.flatten
  end

  def calculate_section_change(metrics)
    metrics.each_with_index.inject([]) do |metric, (today, index)|
      tomorrow = metrics[index + 1]
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

  def add_earliest_date(ordered_metrics)
    # first_focus_metric = get_metric(JSON.parse(ordered_metrics[0]))
    first_focus_metric = get_metric(ordered_metrics[0])
    return ordered_metrics unless first_focus_metric && defined?(first_focus_metric.data)
    # hash_data      = first_focus_metric.data.inject([]) {|d, m| d << JSON.parse(m)}
    # ordered_data   = hash_data.sort_by {|d| format_date(d.fetch('date'))}

    # ordered_data   = ordered_metrics.sort_by {|d| format_date(d.fetch('date'))}
    # earliest_date  = ordered_data[0].fetch('date')


    earliest_date  = ordered_metrics[0].fetch('date')
    # earlist_metric = {focus_metric: first_focus_metric.id, date: earliest_date}.to_json
    earlist_metric = {'focus_metric' => first_focus_metric.id, 'date' => earliest_date}
    ordered_metrics.unshift(earlist_metric)
  end

  def process_metrics(ordered_metrics)
    data = []
    until ordered_metrics.empty? do
      # focus_metric            = JSON.parse(ordered_metrics.shift)

      focus_metric            = ordered_metrics.shift

      next_metric             = ordered_metrics[0] || today_metric

      # to_date                 = JSON.parse(next_metric).fetch('date')

      to_date                 = next_metric.fetch('date')

      # focus_metric['to_date'] = format_date(to_date) -1
      focus_metric = focus_metric.merge({'to_date' => format_date(to_date) -1})
      # byebug
      data << process_metric(focus_metric)
    end
    data
  end

  def process_metric(focus_metric)
    metric_data = get_metric_data(focus_metric)
    return {} unless metric_data
    get_data(focus_metric, metric_data)
  end

  def get_metric(focus_metric)
    # byebug
    focus_id = focus_metric.fetch('focus_metric') {nil}
    # focus_id = focus_metric.fetch(:focus_metric).to_i
    metric   = program_metrics.select { |m| m.id == focus_id }.first
    return {} unless metric && metric.data
    metric
  end

  def get_metric_data(focus_metric)
    metric = get_metric(focus_metric)
    process_metric_data(metric)
  end

  def process_metric_data(focus_metric)
    return focus_metric if focus_metric == {}
    focus_metric.data.map do |d|
      JSON.parse(d).
        merge('metric' => focus_metric.title)
    end
    # focus_metric.data.map {|metric| metric.merge(metric: focus_metric.title)}
  end

  def get_data(focus_metric, metric_data)
    # byebug
    from_date = format_date(focus_metric.fetch('date')) - 1
    # from_date = format_date(focus_metric.fetch(:date)) - 1
    # to_date   = focus_metric.fetch('to_date')
    # byebug
    # byebug
    to_date   = focus_metric.fetch('to_date')
    data      = filter_metric_data(metric_data, from_date, to_date)
    data ? data : {}
  end

  def filter_metric_data(metric_data, from_date, to_date)
    metric_data.select do |m|
      date = format_date(m.fetch('date'))
      (from_date..to_date).cover?(date)
    end
  end

  def today_metric
    today = Date.today
    # {'date'=>"#{today.year}-#{today.month}-#{today.day}"}.to_json
    {'date'=>"#{today.year}-#{today.month}-#{today.day}"}
  end

  def format_date(date)
    Date.strptime(date, '%Y-%m-%d')
  end
end

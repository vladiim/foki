class FocusMetric
  attr_reader :program
  def initialize(program)
    @program = program
  end

  def json_data
    data.map { |d| d.to_json }
    # data
  end

  private

  # should get day before metric focus day so can get
  # change value for metric from start of focus
  def data
    return {} if program.focus_metric.nil?
    ordered_metrics = program.ordered_metrics.dup
    result = process_metrics(ordered_metrics)

    # split by metric section

    result.each.inject([]) do |final_array, focus_array|

      final_array << focus_array.each_with_index.inject([]) do |res, (today, index)|
        tomorrow = focus_array[index + 1]
        if tomorrow
          tom_val  = tomorrow.fetch('value').to_f
          tod_val  = today.fetch('value').to_f
          tomorrow = tomorrow.merge(change: (tom_val - tod_val) / tod_val)
          res << tomorrow
        end
        res
      end

      final_array

    end.flatten
  end

  # make ordered metrics an object?
  def process_metrics(ordered_metrics)
    data = []
    until ordered_metrics.empty? do
      focus_metric            = JSON.parse(ordered_metrics.shift)
      next_metric             = ordered_metrics[0] || today_metric
      to_date                 = JSON.parse(next_metric).fetch('date')
      focus_metric['to_date'] = format_date(to_date) -1
      data << process_metric(focus_metric)
    end
    data
  end

  def process_metric(focus_metric)
    metric_data = get_metric_data(focus_metric)
    return {} unless metric_data
    get_data(focus_metric, metric_data)
  end

  def get_metric_data(focus_metric)
    focus_id     = focus_metric.fetch('focus_metric').to_i
    focus_metric = program.metrics.select { |m| m.id == focus_id }.first
    return {} unless focus_metric && focus_metric.data
    process_metric_data(focus_metric)
  end

  def process_metric_data(focus_metric)
    focus_metric.data.map do |d|
      JSON.parse(d).
        merge(metric: focus_metric.title)
    end
  end

  def get_data(focus_metric, metric_data)
    # from_date = format_date(focus_metric.fetch('date'))
    from_date = format_date(focus_metric.fetch('date')) - 1
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

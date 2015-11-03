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
    # all_data = add_earliest_date(focus_metric_data)
    calculate_all_change(focus_metric_data)
  end

  def add_earliest_date(metrics)
    return [] if metrics.empty?
    first_focus_metric = get_metric(metrics[0])
    return metrics unless first_focus_metric && defined?(first_focus_metric.data)
    metrics.unshift(earliest_metric(first_focus_metric)).flatten
  end

  # def add_earliest_date(metric_data)
  #   return [] if metric_data.empty?
  #   first_focus_metric = get_metric(metrics[0])
  #   return metric_data unless first_focus_metric && defined?(first_focus_metric.data)
  #   metric_data.unshift(earliest_metric(first_focus_metric)).flatten
  # end

  def earliest_metric(first_focus_metric)
    earliest_date  = first_focus_metric.data.map {|data| JSON.parse(data).fetch('date')}.min
    # earliest_datum = first_focus_metric.data.select {|data| JSON.parse(data).fetch('date') == earliest_date}.first
    # earliest_value = JSON.parse(earliest_datum).fetch('value')
    # {'date' => earliest_date, 'value' => earliest_value,'metric' => first_focus_metric.title}
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

# class FocusMetric
#   attr_reader :program, :program_metrics
#   def initialize(program)
#     @program         = program
#     @program_metrics = program.metrics
#   end
#
#   def json_data
#     data.map { |d| d.to_json }
#   end
#
#   private
#
#   def data
#     return {} if program.focus_metric.nil?
#     ordered_metrics = program.ordered_metrics.dup
#     all_metrics     = add_earliest_date(ordered_metrics.dup)
#     metrics         = process_metrics(all_metrics)
#     calculate_each_change(metrics)
#   end
#
#   def calculate_each_change(metrics)
#     metrics.each.inject([]) do |result, metrics_section|
#       result << calculate_section_change(metrics_section)
#     end.flatten
#   end
#
#   def calculate_section_change(metrics)
#     metrics.each_with_index.inject([]) do |metric, (today, index)|
#       tomorrow = metrics[index + 1]
#       metric << calculate_change(today, tomorrow) if tomorrow
#       metric
#     end
#   end
#
#   def calculate_change(today, tomorrow)
#     tom_val = tomorrow.fetch('value').to_f
#     tod_val = today.fetch('value').to_f
#     change  = (tom_val - tod_val) / tod_val
#     tomorrow.merge(change: change)
#   end
#
#   def add_earliest_date(ordered_metrics)
#     first_focus_metric = get_metric(JSON.parse(ordered_metrics[0]))
#     return ordered_metrics unless first_focus_metric && defined?(first_focus_metric.data)
#     hash_data      = first_focus_metric.data.inject([]) {|d, m| d << JSON.parse(m)}
#     ordered_data   = hash_data.sort_by {|d| format_date(d.fetch('date'))}
#     earliest_date  = ordered_data[0].fetch('date')
#     earlist_metric = {focus_metric: first_focus_metric.id, date: earliest_date}.to_json
#     ordered_metrics.unshift(earlist_metric)
#   end
#
#   def process_metrics(ordered_metrics)
#     data = []
#     until ordered_metrics.empty? do
#       focus_metric            = JSON.parse(ordered_metrics.shift)
#       next_metric             = ordered_metrics[0] || today_metric
#       to_date                 = JSON.parse(next_metric).fetch('date')
#       focus_metric['to_date'] = format_date(to_date) -1
#       data << process_metric(focus_metric)
#     end
#     data
#   end
#
#   def process_metric(focus_metric)
#     metric_data = get_metric_data(focus_metric)
#     return {} unless metric_data
#     get_data(focus_metric, metric_data)
#   end
#
#   def get_metric(focus_metric)
#     focus_id = focus_metric.fetch('focus_metric').to_i
#     metric   = program_metrics.select { |m| m.id == focus_id }.first
#     return {} unless metric && metric.data
#     metric
#   end
#
#   def get_metric_data(focus_metric)
#     metric = get_metric(focus_metric)
#     process_metric_data(metric)
#   end
#
#   def process_metric_data(focus_metric)
#     return focus_metric if focus_metric.is_a?(Hash)
#     focus_metric.data.map do |d|
#       JSON.parse(d).
#         merge(metric: focus_metric.title)
#     end
#   end
#
#   def get_data(focus_metric, metric_data)
#     from_date = format_date(focus_metric.fetch('date')) - 1
#     to_date   = focus_metric.fetch('to_date')
#     data      = filter_metric_data(metric_data, from_date, to_date)
#     return {} unless data
#     data
#   end
#
#   def filter_metric_data(metric_data, from_date, to_date)
#     metric_data.select do |m|
#       date = format_date(m.fetch('date'))
#       (from_date..to_date).cover?(date)
#     end
#   end
#
#   def today_metric
#     today = Date.today
#     {'date'=>"#{today.year}-#{today.month}-#{today.day}"}.to_json
#   end
#
#   def format_date(date)
#     Date.strptime(date, '%Y-%m-%d')
#   end
# end

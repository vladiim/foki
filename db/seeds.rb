@user    = User.first
@program = @user.programs.create(title: 'Audi')

['CLV', 'CAC'].each { |title| @program.metrics.create(title: title) }

def get_focus_metric(metric, index, today)
  first = today - 100
  second = today - 30
  return [{'date' => "#{first.year}-#{first.month}-#{first.day}", 'focus_metric' => metric.id}.to_json] if index == 0
  {'date' => "#{second.year}-#{second.month}-#{second.day}", 'focus_metric' => metric.id}.to_json
end

def gen_data(today)
  100.times.inject([]) do |d, n|
    current_day = today - n
    d << {'date' => "#{current_day.year}-#{current_day.month}-#{current_day.day}", 'value' => rand(100...1000)}.to_json
  end
end

def update_focus_metric(focus_metric)
  focus_metric = @program.focus_metric << focus_metric if @program.focus_metric
  @program.update(focus_metric: focus_metric)
end

@program.metrics.each_with_index do |metric, index|
  today        = Date.today
  focus_metric = get_focus_metric(metric, index, today)
  data         = gen_data(today)
  update_focus_metric(focus_metric)
  metric.update(data: data)
end

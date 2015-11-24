class Program < ActiveRecord::Base
  # belongs_to :user

  has_many :program_teams
  has_many :users, through: :program_teams

  has_many :metrics, dependent: :destroy
  has_many :projects, dependent: :destroy

  validates_presence_of :title

  attr_reader :updated_focus_metric
  def update_focus_metric(metric_id)
    @updated_focus_metric = { date: Date.today.strftime('%Y-%m-%d'), focus_metric: metric_id}.to_json
    focus_metric? ? merge_focus_metric : create_focus_metric
    save
  end

  def focus_data
    FocusMetric.new(self).json_data
  end

  def focus_data_dates
    FocusMetric.new(self).data.map { |d| d.fetch('date') }
  end

  def latest_metric_id
    return if focus_metric.nil?
    latest_metric = JSON.parse(ordered_metrics.last)
    latest_metric.fetch('focus_metric')
  end

  def ordered_metrics
    ensure_json_metrics.flatten.sort_by do |metric|
      parsed_metric = JSON.parse(metric)
      Date.strptime(parsed_metric.fetch('date'), '%Y-%m-%d')
    end
  end

  def latest_metric_title
    return 'No focus metric' unless latest_metric_id
    latest_metric.title
  end

  def latest_focus_metric_date
    @latest_focus_metric_date ||= calc_latest_focus_metric_date
  end

  def data
    return 0 unless latest_metric_id
    latest_metric.data
  end

  def metric_title_syms
    metric_titles.map { |m| m.to_sym }
  end

  def metric_titles
    memoised_metrics.map { |m| m.title }
  end

  def to_date
    Date.strptime(latest_focus_metric_date).strftime("%d %b %Y")
  end

  def from_date
    date = format_date(latest_focus_metric_date) - 14
    Date.strptime(date.to_s).strftime("%d %b %Y")
  end

  private

  def calc_latest_focus_metric_date
    data = FocusMetric.new(self).data
    return Today.new.value if data.empty?
    data.sort { |a, b| format_date(a.fetch('date')) <=> format_date(b.fetch('date')) }[-1]
      .fetch('date')
  end

  def memoised_metrics
    @memoised_metrics ||= metrics
  end

  def latest_metric
    @latest_metric ||= Metric.find(latest_metric_id)
  end

  def ensure_json_metrics
    focus_metric.map do |metric|
      metric.is_a?(Hash) ? metric.to_json : metric
    end
  end

  def merge_focus_metric
    updated_date = JSON.parse(updated_focus_metric).fetch('date')
    self.focus_metric = [
      passed_focus_metrics(updated_date), updated_focus_metric
    ].flatten
  end

  def passed_focus_metrics(updated_date)
    self.focus_metric.select do |metric|
      JSON.parse(metric).fetch('date') != updated_date
    end
  end

  def create_focus_metric
    self.focus_metric = [updated_focus_metric]
  end

  def format_date(date)
    Date.strptime(date)
  end
end

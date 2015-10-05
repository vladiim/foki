class Program < ActiveRecord::Base
  belongs_to :user
  has_many :metrics, dependent: :destroy

  validates_presence_of :title

  attr_reader :updated_focus_metric
  def update_focus_metric(metric_id)
    @updated_focus_metric = { 'date' => Date.today.strftime('%Y-%m-%d'), 'focus_metric' => metric_id}
    focus_metric? ? merge_focus_metric : create_focus_metric
    save
  end

  def focus_data
    FocusMetric.new(self).data
  end

  def latest_metric
    return focus_metric if focus_metric.nil?
    ordered_metrics.last.fetch('focus_metric')
  end

  def ordered_metrics
    focus_metric.flatten.sort_by do |item|
      Date.strptime(item.fetch('date'), '%Y-%m-%d')
    end
  end

  def latest_metric_title
    metric_id = latest_metric
    metrics.all.each do |metric|
      metric.id == metric_id
    end.first.title if metric_id
  end

  private

  def merge_focus_metric
    self.focus_metric = [self.focus_metric, updated_focus_metric].flatten
  end

  def create_focus_metric
    self.focus_metric = updated_focus_metric
  end
end

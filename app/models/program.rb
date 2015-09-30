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

  private

  # def focus_metric?
  #
  # end

  def merge_focus_metric
    self.focus_metric = self.focus_metric.merge(updated_focus_metric)
  end

  def create_focus_metric
    self.focus_metric = updated_focus_metric
  end
end

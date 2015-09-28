require 'csv'
require 'json'

class MetricUpdater
  attr_reader :data_store
  def initialize(id, data_store_class = Metric)
    @data_store = data_store_class.find(id)
  end

  def save_data(file)
    data_store.data = csv_to_json(file)
    data_store.save
  end

  private

  def csv_to_json(file)
    csv = CSV.read(file, headers: true)
    csv.to_a.to_h.to_json
  end
end

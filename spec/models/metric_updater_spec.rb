require_relative '../spec_helper_lite'
require_relative '../../app/models/metric_updater'

RSpec.describe MetricUpdater do
  let(:subject)     { described_class.new(1, ds_class) }
  let(:json)        { "{\"date\":\"value\",\"2015-09-01\":\"30\"}" }
  let(:file)        { File.open("#{Dir.pwd}/spec/stubs/data.csv", 'rb') }
  let(:ds_class)    { spy('Data store class') }
  let(:ds_instance) { double('Data store instance') }

  before { allow(ds_class).to receive(:find) { ds_instance } }

  describe '.new(id)' do
    it 'finds the metric and sets it as the @data_store' do
      expect(subject.data_store).to eql(ds_instance)
      expect(ds_class).to have_received(:find).with(1)
    end
  end

  describe '#save_data(file)' do
    let(:result) { subject.save_data(file) }

    before do
      allow(ds_instance).to receive(:data=).with(anything)
      allow(ds_instance).to receive(:save)
      result
    end

    it 'passes the json data to the data_store' do
      expect(ds_instance).to have_received(:data=).with(json)
    end

    it 'saves the data_store' do
      expect(ds_instance).to have_received(:save)
    end
  end
end

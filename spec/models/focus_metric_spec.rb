require 'spec_helper'

RSpec.describe FocusMetric do
  let(:program) { create :program }
  let(:subject) { described_class.new(program) }

  describe '.new' do
    it 'stores the program locally' do
      expect(subject.program).to eql(program)
    end
  end

  describe '#json_data' do
    let(:result) { subject.json_data }

    context 'without program focus data' do
      before { allow(program).to receive(:focus_metric) { nil } }

      it 'returns an empty hash' do
        expect(result).to eql([])
      end
    end

    context 'with program focus data' do
      let(:data) { [{"date"=>"2015-10-05", "value"=>"2", :metric=>"METRIC_TITLE", :change=>1.0}].map { |d| d.to_json } }

      it 'returns the relevant data within the timeframe', focus: true do
        expect(result).to eql(data)
      end
    end

    context 'with multiple focus metrics' do
     let(:program) { create :program, :multiple_focus_metrics }
     let(:data)    { [{"date"=>"2015-10-02","value"=>"2",:metric=>"SECOND_METRIC_TITLE",:change=>1.0},{"date"=>"2015-10-03","value"=>"3",:metric=>"SECOND_METRIC_TITLE",:change=>0.5},{"date"=>"2015-10-05", "value"=>"2", :metric=>"METRIC_TITLE", :change=>1.0}].map { |d| d.to_json } }

      it 'gets the data for dates between focus metrics' do
        expect(result).to eql(data)
      end
    end

    context 'first focus metric has older previous data' do
      let(:program) { create :program, :focus_metrics_older_data }
      let(:data)    { (1..19).each.inject([]) {|d, i| d << {date: "2015-10-#{i + 1}", value: 1, metric: 'OLDER_METRIC_TITLE', change: 0.0}.to_json } }

      it "pulls the focus metric's older data", focus: true do
        # byebug
        byebug
        expect(result).to eql(data)
      end
    end

    context 'without metric data'  do
      let(:program) { create :program, :no_metric_data }

      it 'returns an empty hash' do
        expect(result).to eql([])
      end
    end

    context 'deleted focus metric' do
      let(:program) { create :program, :deleted_focus_metric }

      it 'returns an empty hash' do
        expect(result).to eql([])
      end
    end
  end
end

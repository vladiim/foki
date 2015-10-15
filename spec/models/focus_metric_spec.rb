require 'spec_helper'

RSpec.describe FocusMetric do
  let(:program) { create :program }
  let(:subject) { described_class.new(program) }

  describe '.new' do
    it 'stores the program locally' do
      expect(subject.program).to eql(program)
    end
  end

  describe '#data' do
    let(:result) { subject.json_data }

    context 'without program focus data' do
      before { allow(program).to receive(:focus_metric) { nil } }

      it 'returns an empty hash' do
        expect(result).to eql([])
      end
    end

    context 'with program focus data' do
      let(:data) { [{"date"=>"2015-10-05", "value"=>"2", :metric=>"METRIC_TITLE", :change=>1.0}].map { |d| d.to_json } }
      # let(:data) { ["{\"date\":\"2015-10-05\",\"value\":\"2\",\"metric\":\"METRIC_TITLE\",\"change\":1.0}"] }
      # let(:data) { [{"date"=>"2015-10-04", "change"=>"NA", 'value'=>'1', "metric"=>'METRIC_TITLE'}, {"date"=>"2015-10-05", "change"=>"1.0", 'value'=>'2', "metric"=>'METRIC_TITLE'}].map { |d| d.to_json } }
      # let(:data) { [{"date"=>"2015-10-04", "change"=>"1"}, {"date"=>"2015-10-05", "change"=>"2"}].map { |d| d.to_json } }

      it 'returns the relevant data within the timeframe' do
        expect(result).to eql(data)
      end
    end

   context 'with multiple focus metrics' do
    let(:program) { create :program, :multiple_focus_metrics }
    #  let(:data) { [{"date"=>"2015-10-01", "value"=>"1"},{"date"=>"2015-10-02", "change"=>"2"},{"date"=>"2015-10-03", "change"=>"3"},{"date"=>"2015-10-04", "change"=>"1"}, {"date"=>"2015-10-05", "change"=>"2"}].map { |d| d.to_json } }
    #  let(:data) { [{"date"=>"2015-10-01", "value"=>"1", "change"=>nil, "metric"=>'SECOND_METRIC_TITLE'},{"date"=>"2015-10-02", "value"=>"2", "change"=>"1.0", "metric"=>'SECOND_METRIC_TITLE'},{"date"=>"2015-10-03", "value"=>"3", "change"=>"0.5", "metric"=>'SECOND_METRIC_TITLE'},{"date"=>"2015-10-04", "value"=>"1", "change"=>"NA", "metric"=>'METRIC_TITLE'}, {"date"=>"2015-10-05", "value"=>"2", "change"=>"1.0", "metric"=>'METRIC_TITLE'}].map { |d| d.to_json } }
    # let(:data) { [{"date"=>"2015-10-02", "value"=>"2", "change"=>"1.0", "metric"=>'SECOND_METRIC_TITLE'},{"date"=>"2015-10-03", "value"=>"3", "change"=>"0.5", "metric"=>'SECOND_METRIC_TITLE'},{"date"=>"2015-10-05", "value"=>"2", "change"=>"1.0", "metric"=>'METRIC_TITLE'}].map { |d| d.to_json } }
    # let(:data) { ["{\"date\":\"2015-10-02\",\"value\":\"2\",\"metric\":\"SECOND_METRIC_TITLE\",\"change\":1.0}", "{\"date\":\"2015-10-03\",\"value\":\"3\",\"metric\":\"SECOND_METRIC_TITLE\",\"change\":0.5}", "{\"date\":\"2015-10-05\",\"value\":\"2\",\"metric\":\"METRIC_TITLE\",\"change\":1.0}"] }
    let(:data) { [{"date"=>"2015-10-02","value"=>"2",:metric=>"SECOND_METRIC_TITLE",:change=>1.0},{"date"=>"2015-10-03","value"=>"3",:metric=>"SECOND_METRIC_TITLE",:change=>0.5},{"date"=>"2015-10-05", "value"=>"2", :metric=>"METRIC_TITLE", :change=>1.0}].map { |d| d.to_json } }

     it 'gets the data for dates between focus metrics' do
       expect(result).to eql(data)
     end
   end

    context 'without metric data' do
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

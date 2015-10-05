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
    let(:result) { subject.data }

    context 'without program focus data' do
      before { allow(program).to receive(:focus_metric) { nil } }

      it 'returns an empty hash' do
        expect(result).to eql({})
      end
    end

    context 'with program focus data' do
      let(:data) { [{"date"=>"2015-10-04", "value"=>"1"}] }

      it 'returns the relevant data within the timeframe' do
        expect(result).to eql(data)
      end
    end

    context 'without metric data' do
      let(:program) { create :program, :no_metric_data }

      it 'returns an empty hash' do
        expect(result).to eql([{}])
      end
    end

    context 'focus dates and metric dates are different' do
      let(:program) { create :program, :focus_metric_different_dates }

      it 'returns an empty hash' do
        expect(result).to eql([{}])
      end
    end
  end
end

require 'spec_helper'

RSpec.describe Program, type: :model do
  let(:subject) { build_stubbed :program }

  describe '#update_focus_metric(focus_metric)' do
    let(:focus_metric)         { 1 }
    let(:result)               { subject.update_focus_metric(focus_metric) }
    let(:updated_focus_metric) { {'date' => Date.today.strftime('%Y-%m-%d'), 'focus_metric' => focus_metric} }

    before do
      allow(subject).to receive(:save) { true }
    end

    it 'updates the focus_metric hash' do
      result
      expect(subject.focus_metric).to eql(updated_focus_metric)
    end

    context 'the focus_metric is nil' do
      before { subject.focus_metric = nil }

      it 'makes the focus metric the focus_metric' do
        result
        expect(subject.focus_metric).to eql(updated_focus_metric)
      end
    end
  end

  describe 'focus metric' do
    let(:fmetric) { [{"date"=>"2015-10-01", "focus_metric"=>"LATEST METRIC"}, {"date"=>"2015-09-01", "focus_metric"=>"EARLIEST"}].map {|d| d.to_json } }
    before { allow(subject).to receive(:focus_metric) { fmetric } }

    describe '#latest_metric' do
      let(:result) { subject.latest_metric }

      context 'with focus_metric' do
        it 'returns the latest metric' do
          expect(result).to eql('LATEST METRIC')
        end
      end

      context 'with no focus_metric' do
        let(:fmetric) { nil }

        it 'returns no focus metric' do
          expect(result).to eql(nil)
        end
      end
    end

    describe '#latest_metric_title' do
      let(:result)  { subject.latest_metric_title }
      let(:query)   { double('Metrics.all query' )}
      let(:metrics) { [OpenStruct.new(title: 'TITLE', id: 'LATEST METRIC')]}

      before do
        allow(subject).to receive(:metrics) { query }
        allow(query).to receive(:all) { metrics }
      end

      context 'with focus metric' do
        it 'returns the latest metric title' do
          expect(result).to eql('TITLE')
        end
      end

      context 'without focus metric' do
        let(:fmetric) { nil }
        it 'returns no focus metric' do
          expect(result).to eql('No focus metric')
        end
      end
    end
  end
end

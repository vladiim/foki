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
end

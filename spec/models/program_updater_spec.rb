require_relative '../spec_helper_lite'
require_relative '../../app/models/program_updater'

RSpec.describe ProgramUpdater do
  let(:program) { double('Program') }
  let(:subject) { described_class.new(program) }

  describe '.new' do
    it 'saves the program' do
      expect(subject.program).to eql(program)
    end
  end

  describe '#update(params)' do
    let(:result) { subject.update(params) }

    context 'without a focus metric' do
      let(:params) { { title: 'title' } }

      it 'updates the program' do
        allow(program).to receive(:update).with(params)
        expect(program).to receive(:update).with(params)
        result
      end
    end

    context 'with a focus metric' do
      let(:params) { { focus_metric: 'FOCUS_METRIC' } }
      before { allow(program).to receive(:update_focus_metric) }

      it 'appends the program.data' do
        result
        expect(program).to have_received(:update_focus_metric).with('FOCUS_METRIC')
      end
    end


    # context 'with a focus metric and other params' do
  end
end

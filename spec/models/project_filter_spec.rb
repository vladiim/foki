require 'spec_helper'

RSpec.describe ProjectFilter do
  let(:program) { double('Program') }
  let(:metric)  { 'METRIC' }
  let(:params)  { {"metric" => metric, "program_id" => "PROGRAM_ID", 'status' => 'live'} }
  let(:subject) { described_class.new(program, params) }

  describe '.new(params)' do
    before { subject }

    it 'finds the relevant program' do
      expect(subject.program).to eq(program)
    end

    it 'remembers the status' do
      expect(subject.live).to eql(true)
    end

    context 'with metric' do
      it 'remembers the metric' do
        expect(subject.metric).to eq(metric)
      end
    end
  end

  describe '#process' do
    let(:result) { subject.process }
    before {allow(program).to receive(:projects) { projects }}

    context 'specific metric', focus: true do
      let(:params) { {"metric" => metric, "program_id"=>"PROGRAM_ID", 'status' => 'all'} }
      let(:filtered_not_live) {  OpenStruct.new(tags: [metric], live: false) }
      let(:filtered_projects) { [OpenStruct.new(tags: [metric], live: true), filtered_not_live] }
      let(:projects)          { filtered_projects.dup.unshift(OpenStruct.new(tags: ['BOO'], live: false)) }

      context 'all status' do
        it "filters the program's project by metric type" do
          expect(result).to eq(filtered_projects)
        end
      end

      context 'not live' do
        let(:params) { {"metric"=>metric, "program_id"=>"PROGRAM_ID", 'status' => 'blah'} }

        it 'returns the filtered projects' do
          expect(result).to eq([filtered_not_live])
        end
      end
    end
  end
end

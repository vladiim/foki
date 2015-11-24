require 'spec_helper'

RSpec.describe Invite do
  describe '.new' do
    let(:user)    {create :user}
    let(:program) {create :program}
    let(:team)    {OpenStruct.new(program_id: program.id, to_id: user.id, from_id: user.id)}
    let(:result)  {described_class.new(team)}

    it 'formats the invite from the team' do
      expect(result.from).to eql user.name
      expect(result.title).to eql program.title
    end
  end

  describe '.all' do
    let(:result) {described_class.all(id)}

    context 'no invites' do
      let(:id) {2}
      it 'returns an empty array' do
        expect(result).to eq []
      end
    end

    context 'user invites' do
      let(:program_team) {create :program_team}
      let(:id)           {program_team.to_id}

      before do
        allow(Program).to receive(:find) {OpenStruct.new(title: 'PROGRAM TITLE')}
        allow(User).to receive(:find).with(1) {OpenStruct.new(name: 'USERNAME')}
      end

      it 'returns a completed array of invites' do
        expect(result[0].from).to eq 'USERNAME'
        expect(result[0].title).to eq 'PROGRAM TITLE'
      end
    end
  end
end

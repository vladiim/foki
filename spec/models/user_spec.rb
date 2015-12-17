require 'spec_helper'

RSpec.describe User do
  let(:subject) {create :user}

  describe '#name' do
    context 'without a firstname' do
      it "uses the begining of the user's email" do
        name = subject.email[0, subject.email.index('@')]
        expect(subject.name).to eql name
      end
    end

    context 'with a username' do
      let(:username) {'NAME'}
      let(:subject)  {create :user, username: username}

      it 'uses the username' do
        expect(subject.name).to eql username
      end
    end
  end

  describe '#all_programs' do
    let(:result) {subject.all_programs}

    context 'user with programs' do
      let(:subject) {create :user, :with_program}

      it 'returns the program' do
        expect(result.first).to eql Program.last
      end
    end

    context 'user invited to a program', focus: true do
      let(:subject) {create :user, :with_program_team_invite}

      it "doesn't return the program" do
        expect(result).to be_empty
      end
    end
  end
end

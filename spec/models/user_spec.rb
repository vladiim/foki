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
end

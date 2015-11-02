require_relative '../features_helper.rb'

RSpec.describe 'user features', type: :feature do
  let(:email)    {"user#{rand(10000000)}@email.com"}
  let(:password) {'password'}

  describe 'sign in' do
    context 'user exists' do
      before { create :user, email: email, password: password }

      it 'is successful' do
        sign_in_with(email, password)
        expect(page).to have_content 'Signed in successfully.'
      end
    end
  end
end

require_relative '../features_helper.rb'

RSpec.describe 'user features', type: :feature do
  let(:email)    {"user#{rand(10000000)}@email.com"}
  let(:password) {'password'}
  let(:user)     {create :user, :with_program, email: email, password: password}

  describe 'program team' do
    before do
      user
      sign_in_with(email, password)
      visit(program_path(user.programs.first))
    end

    context 'user creates program' do
      it "lists the user's name" do
        expect(page).to have_content user.name
      end
    end

    context 'user adds team member', js: true do

      context 'team member exsits as user' do
        let(:team_member) {create :user}

        it 'sends the team member an invite' do
          click_link 'Invite new'
          within('#teamMemberInviteModal') do
            fill_in 'Email', with: team_member.email
            click_button 'Invite team member'
          end
          click_link 'Logout'
          sign_in_with(team_member.email, team_member.password)
          expect(page).to have_content "#{user.name} has invited you to join"
        end
      end
    end
  end
end

require_relative '../features_helper.rb'

RSpec.describe 'user features', type: :feature do
  let(:email)    {"user#{rand(10000000)}@email.com"}
  let(:password) {'password'}
  let(:user)     {create :user, :with_program, email: email, password: password}

  describe 'program team' do
    before do
      sign_in_with(user.email, user.password)
      visit(program_path(user.all_programs.first.id))
    end

    context 'user creates program' do
      it "lists the user's name" do
        expect(page).to have_content user.name
      end
    end

    context 'user adds team member' do

      context 'team member is a user' do
        let(:team_member) {create :user}

        before do
          click_link 'Invite new'
          within('#teamMemberInviteModal') do
            fill_in 'Email', with: team_member.email
            click_button 'Invite team member'
          end
          click_link 'Logout'
          sign_in_with(team_member.email, team_member.password)
        end

        it 'shows the invite on the project index' do
          expect(page).to have_content "#{user.name} has invited you to join"
        end

        context 'team member accepts the invite' do
          it 'redirects to the program page and adds the team member' do
            click_button 'Accept'
            within('.program-team') {expect(page).to have_content team_member.name}
          end
        end

        context 'team member declines the invite' do
          it 'deletes the invite and stays on the current page' do
            click_button 'Decline'
            expect(page).to have_content 'Programs'
            expect(page).not_to have_content 'has invited you to join'
          end
        end

        context 'user deletes the program' do
          it 'deletes the invite' do
            Program.all.each(&:destroy)
            visit programs_path
            expect(page).not_to have_content "#{user.name} has invited you to join"
          end
        end
      end

      context 'team member is not a user' do
      end
    end
  end
end

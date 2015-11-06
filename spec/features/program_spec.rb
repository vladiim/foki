require_relative '../features_helper.rb'

RSpec.describe 'program features', type: :feature, js: true do
  let(:title) { 'TITLE' }

  describe 'create program' do
    # it 'creates and redirects to a program' do
    #   user = create :user
    #   sign_in_with(user.email, user.password)
    #   within('.add-program') { click_on('+') }
    #   fill_in 'program_title', with: title
    #   click_button 'Create program'
    #   within('h3.panel-title') { expect(page).to have_content(title) }
    # end
  end

  describe 'update program' do
    # it 'updates the program to the new title' do
    #   user = create :user
    #   program = user.programs.create title: 'TIT'
    #   sign_in_with(user.email, user.password)
    #   open_settings_modal
    #   fill_in 'program_title', with: title
    #   click_button 'Update'
    #   expect(current_path).to eql program_path(program)
    #   expect(page).to have_content "#{title} updated."
    # end
  end

  describe 'delete program' do
    # it 'removes the program' do
      # user = create :user
      # program = user.programs.create(title: title)
      # sign_in_with(user.email, user.password)
      # open_settings_modal
      # click_link 'Delete program permanantly'
      # page.driver.browser.switch_to.alert.accept
      # expect(page).no_to have_content(title)
    # end
  end
end

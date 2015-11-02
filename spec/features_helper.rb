require_relative 'spec_helper.rb'

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

module Features
  module SessionHelpers
    def sign_in_with(email, password)
      visit '/'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      click_button 'Sign in'
    end

    def open_settings_modal
      find('.glyphicon-cog').click
    end
  end
end

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end

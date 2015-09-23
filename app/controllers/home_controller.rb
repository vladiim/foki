class HomeController < ApplicationController
  def index
    @login = LoginForm.new
  end
end

class LoginController < ApplicationController
  before_filter :authenticate_user!
  # protected
  def post
    redirect_to :programs
  end
end

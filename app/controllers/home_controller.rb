class HomeController < ApplicationController
  before_filter :set_resource

  def index
    user_signed_in? ? authenticated_home : un_authenticated_home
  end

  private

  def un_authenticated_home
    @user = User.new
  end

  def authenticated_home
    @programs = current_user.programs
    render 'programs/index'
  end

  def set_resource
    @resource_name = :program
    @resource_path  = programs_path
  end
end

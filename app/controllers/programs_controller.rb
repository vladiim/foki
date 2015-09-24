class ProgramsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @program = Program.new(params[:id].match(/\D\w+/)[0].gsub('-', ''))
  end
end

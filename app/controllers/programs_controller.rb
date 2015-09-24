class ProgramsController < ApplicationController
  def index
  end

  def show
    @program = Program.new(params[:id].match(/\D\w+/)[0].gsub('-', ''))
  end
end

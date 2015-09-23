class ProjectsController < ApplicationController
  def index
  end

  def show
    @project = Project.new(params[:id].match(/\D\w+/)[0].gsub('-', ''))
  end
end

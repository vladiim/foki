class ProgramsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_resource, except: :show

  def index
    @programs = current_user.programs
  end

  def show
    @program = Program.find(params[:id])
    @kpis    = [OpenStruct.new(title: 'Sign up', stat: '2%', change: '0.5%', editable: true),
                OpenStruct.new(title: 'CLV', stat: '4%', change: '-2.3%', editable: true),
                OpenStruct.new(title: 'Newsletter', stat: '3%', change: '0%', editable: true)]
  end

  def create
    # byebug
    @program = current_user.programs.build(program_params)
    if @program.save
      redirect_to @program
    else
      render 'index'
      flash[:error] = 'There was an issue creating the new program'
    end
  end

  def destroy
    Program.find(params[:id]).destroy
    redirect_to action: :index
  end

  private

  def set_resource
    @resource_name = :program
    @resource_path  = programs_path
  end

  def program_params
    params[:program].permit(:title)
  end
end

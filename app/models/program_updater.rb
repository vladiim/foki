class ProgramUpdater
  attr_reader :program
  def initialize(program)
    @program = program
  end

  def update(params)
    focus_metric = params.delete(:focus_metric)
    program.update_focus_metric(focus_metric) if focus_metric
    program.update(params) unless params.empty?
  end
end

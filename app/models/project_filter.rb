class ProjectFilter

  attr_reader :program, :metric, :live, :status
  def initialize(program, params)
    @program = program
    @metric  = params.fetch('metric')
    @status  = params.fetch('status')
    @live    = status == 'live' ? true : false
  end

  def process
    program.projects.select do |project|
      eql_metric?(project) && eql_live?(project)
    end
  end

  private

  def eql_metric?(project)
    return true if metric == 'all'
    project.tags.include?(metric)
  end

  def eql_live?(project)
    return true if status == 'all'
    project.live == live
  end
end

class Today
  attr_reader :value
  def initialize
    date   = Date.today
    @value = "#{date.year}-#{date.month}-#{date.day}"
  end
end

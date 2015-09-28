class Metric < ActiveRecord::Base
  belongs_to :program

  validates_presence_of :title
end

class Project < ActiveRecord::Base
  belongs_to :program

  serialize :tags, Array

  validates_presence_of :title
end

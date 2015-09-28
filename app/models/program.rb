class Program < ActiveRecord::Base
  belongs_to :user
  has_many :metrics, dependent: :destroy

  validates_presence_of :title
end

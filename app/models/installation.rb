class Installation < ActiveRecord::Base
  belongs_to :application
  has_many :states

  validates :name, presence: true
end

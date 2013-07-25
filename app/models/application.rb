class Application < ActiveRecord::Base
  has_many :installations

  validates :name, presence: true, uniqueness: true
end

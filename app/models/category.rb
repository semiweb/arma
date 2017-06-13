class Category < ActiveRecord::Base
  has_and_belongs_to_many :changelogs
  belongs_to :application
  validates :name, presence: true
  validates :application_id, presence: true

end

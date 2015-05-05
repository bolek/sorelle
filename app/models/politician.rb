class Politician < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  validates :fec_number, presence: true, uniqueness: true

  belongs_to :party
end

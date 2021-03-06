class Topic < ApplicationRecord
  has_and_belongs_to_many :articles

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

  def display
    name
  end
end


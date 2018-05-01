class Topic < ApplicationRecord
  has_and_belongs_to_many :articles

  validates :name, presence: true, length: { maximum: 100 }
end


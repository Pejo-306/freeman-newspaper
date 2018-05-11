class Article < ApplicationRecord
  belongs_to :column
  has_and_belongs_to_many :topics

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
end


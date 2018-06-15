class Article < ApplicationRecord
  belongs_to :column
  has_and_belongs_to_many :topics
  has_many :comments

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
  validates :views, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :thumbnail_size

  mount_uploader :thumbnail, ThumbnailUploader

  after_initialize :init

  private

  def init
    self.views = 0
  end

  def thumbnail_size
    if thumbnail.size > 5.megabytes
      errors.add :thumbnail, 'should be less than 5MB'
    end
  end
end


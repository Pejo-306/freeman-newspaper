class Column < ApplicationRecord
  belongs_to :author
  has_many :articles

  validates :heuristic_value, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.heuristic_value ||= 0
  end
end


class Author < User
  has_one :column
  before_save :set_defaults

  validates :biography, presence: true

  private

  def set_defaults
    self.author = true
  end
end


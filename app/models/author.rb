class Author < User
  has_one :column
  before_save :set_defaults

  private

  def set_defaults
    self.author = true
  end
end


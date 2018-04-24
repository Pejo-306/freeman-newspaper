class Author < User
  has_many :articles
  before_save :set_defaults

  private

  def set_defaults
    self.author = true
  end
end


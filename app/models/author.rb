class Author < User
  has_one :column

  validate :has_biography

  before_save :set_defaults

  private

  def set_defaults
    self.author = true
  end

  def has_biography
    if self.biography.blank?
      errors.add :biography, 'should not be blank'
    end
  end
end


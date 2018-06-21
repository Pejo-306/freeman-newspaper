class Column < ApplicationRecord
  belongs_to :author
  has_many :articles
end


class Author < User
  has_many :courses, foreign_key: 'author_id', dependent: :nullify
end

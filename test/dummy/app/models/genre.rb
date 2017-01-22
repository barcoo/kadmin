# frozen_string_literal: true
class Genre < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  validates :name, presence: true, length: { in: 1..254 }, uniqueness: true,
                   format: { with: /[a-zA-Z0-9\-_\s]+/, message: 'only alphanumerics, dashes, underscores, and spaces' }
end

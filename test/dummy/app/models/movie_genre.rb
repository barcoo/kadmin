# frozen_string_literal: true
class MovieGenre < ApplicationRecord
  belongs_to :genre
  belongs_to :movie

  validates :movie, presence: true
  validates :genre, presence: true
end

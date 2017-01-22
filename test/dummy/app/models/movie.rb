# frozen_string_literal: true
require 'url_validator'

class Movie < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres

  has_many :movie_casts, dependent: :destroy
  has_many :people, through: :movie_casts
  belongs_to :country

  validates :title, presence: true

  validates :poster_url, url: true
  validates :imdb_url, url: true

  validates :release_date, presence: true
  validate :valid_release_date?

  validates :country, presence: true

  # The very first movie (Roundhay Garden) was released in France on 14 October 1888
  FIRST_MOVIE_DATE = Date.new(1888, 10, 14).freeze
  def valid_release_date?
    return release_date.present? && release_date >= FIRST_MOVIE_DATE
  end
  private :valid_release_date?
end

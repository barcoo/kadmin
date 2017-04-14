# frozen_string_literal: true

class MovieCast < ApplicationRecord
  belongs_to :movie
  belongs_to :person
  belongs_to :role

  validates :movie, presence: true
  validates :person, presence: true
  validates :role, presence: true
end

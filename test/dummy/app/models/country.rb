# frozen_string_literal: true
class Country < ApplicationRecord
  has_many :people
  has_many :movies

  validates :name, presence: true, length: { in: 1..254 }, uniqueness: true,
                   format: { with: /[a-zA-Z\s]+/, message: 'only letters and spaces' }
end

class Person < ActiveRecord::Base
  has_many :group_people, dependent: :destroy, autosave: true
  has_many :groups, through: :group_people
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', dependent: :nullify, autosave: true

  validates :first_name, presence: true, length: { in: 2..254 }
  validates :last_name, presence: true, length: { in: 2..254 }
  validates :sex, presence: true, length: { is: 1 }, inclusion: { in: %w(m f o), message: 'one of m (male), f (female), or o (other)' }
  validate :valid_date_of_birth?

  def valid_date_of_birth?
    return date_of_birth.nil? || (date_of_birth.is_a?(Date) && date_of_birth < Date.current)
  end
  private :valid_date_of_birth?
end

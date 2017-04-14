# frozen_string_literal: true

class AdultPersonForm < Kadmin::Form
  delegate :full_name, to: :model
  delegate_attributes :gender, :first_name, :last_name, :date_of_birth, :groups, read_only: [:group_ids]

  def group_ids=(ids)
    @model.group_ids = ids.reject(&:blank?).map(&:to_i)
  end

  validate :adult?
  def adult?
    cutoff_date = 18.years.ago.beginning_of_day
    if @model.date_of_birth >= cutoff_date
      @errors.add(:date_of_birth, :invalid, message: 'must be 18 years old')
    end
  end
  private :adult?
end

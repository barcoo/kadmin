module Forms
  class PersonForm < Kadmin::Form
    delegate_attributes :sex, :first_name, :last_name, date_of_birth: [:reader]

    validates :adult?

    def initialize(*args)
      super
      raise(ArgumentError, 'Model given should be a person') unless @model.is_a?(Person)
    end

    # @param [Array<String>] value array where 0 is the year, 1 is the month, 2 is the day
    def date_of_birth=(value)
      year = value[0].to_i
      month = value[1].to_i
      day = value[2].to_i

      @model.date_of_birth = Date.new(year, month, day)
    end

    def adult?
      cutoff_date = 18.years.ago.beginning_of_day
      if @model.date_of_birth > cutoff_date
        @errors.add(:date_of_birth, :invalid, message: 'must be 18 years old')
      end
    end
  end
end

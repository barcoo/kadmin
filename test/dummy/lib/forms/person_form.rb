module Forms
  class PersonForm < Kadmin::Form
    delegate_attributes :gender, :first_name, :last_name, :date_of_birth, :groups

    def initialize(*args)
      super
      raise(ArgumentError, 'Model given should be a person') unless @model.is_a?(Person)
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
end

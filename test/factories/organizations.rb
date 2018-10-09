FactoryBot.define do
  factory :kadmin_organization, class: Kadmin::Organization do
    initialize_with do
      Kadmin::Organization.where(name: 'offerista').first_or_initialize # take from seeded database
    end
  end

  factory :kadmin_organization_not_offerista, class: Kadmin::Organization do
    initialize_with do
      Kadmin::Organization.where(name: 'profital').first_or_initialize # take from seeded database
    end
  end
end

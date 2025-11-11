FactoryBot.define do
  factory(:schedule) do
    association :contract_period
    identifier { 'ecf-standard-september' }

    initialize_with do
      Schedule.find_or_create_by(contract_period:, identifier:)
    end

    trait :ect_teacher_type do
      identifier { 'ecf-standard-september' }
    end

    trait :mentor_teacher_type do
      identifier { 'ecf-replacement-april' }
    end
  end
end

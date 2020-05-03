FactoryBot.define do
  factory :user_account do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    state { 'RJ' }
    gender { 'F' }
    country { 'BR' }
    city { 'Rio de Janeiro' }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }

    trait :valid_cpf do
      cpf { CPF.generate(false) }
    end

    trait :invalid_cpf do
      cpf { '11111111111' }
    end
  end
end

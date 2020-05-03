# == Schema Information
#
# Table name: user_accounts
#
#  id              :uuid             not null, primary key
#  birth_date      :date
#  city            :string
#  country         :string(2)
#  cpf             :string           not null
#  email           :string
#  gender          :string(1)
#  invitation_code :string
#  name            :string
#  referral_code   :string
#  state           :string(2)
#  status          :integer          default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
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

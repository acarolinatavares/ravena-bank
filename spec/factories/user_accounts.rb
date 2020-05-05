# == Schema Information
#
# Table name: user_accounts
#
#  id              :uuid             not null, primary key
#  birth_date      :string
#  city            :string
#  country         :string(2)
#  cpf             :string           not null
#  email           :string
#  gender          :string
#  invitation_code :string
#  name            :string
#  password_digest :string
#  referral_code   :string
#  state           :string(2)
#  status          :integer          default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_accounts_on_cpf  (cpf) UNIQUE
#
FactoryBot.define do
  factory :user_account do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    state { 'RJ' }
    gender { 'F' }
    country { 'BR' }
    city { 'Rio de Janeiro' }
    birth_date { '01/07/1991' }
    cpf { CPF.generate(false) }
    password { '123456' }
  end
end

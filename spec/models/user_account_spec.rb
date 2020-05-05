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
require 'rails_helper'

RSpec.describe UserAccount, type: :model do
  it { should validate_presence_of(:cpf) }

  it 'should be invalid if the cpf is invalid' do
    user_account = build :user_account, :invalid_cpf
    expect(user_account.valid?).to be false
  end

  it 'should be valid if the cpf is valid' do
    user_account = build :user_account, :valid_cpf
    expect(user_account.valid?).to be true
  end
end

# == Schema Information
#
# Table name: user_accounts
#
#  id           :uuid             not null, primary key
#  birth_date   :date
#  city         :string
#  country      :string(2)
#  cpf          :string           not null
#  email        :string
#  gender       :string(1)
#  name         :string
#  referal_code :string
#  state        :string(2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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

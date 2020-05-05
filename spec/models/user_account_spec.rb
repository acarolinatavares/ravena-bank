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
require 'rails_helper'

RSpec.describe UserAccount, type: :model do
  it { should validate_presence_of(:cpf) }
  it { should validate_presence_of(:password) }
  it { should allow_value('email@gmail.com').for(:email) }
  it { should_not allow_value('email@gmailcom').for(:email) }
  it { should validate_length_of(:country).is_equal_to(2) }
  it { should validate_length_of(:state).is_equal_to(2) }
  it { should allow_value('01/07/1991').for(:birth_date) }
  it { should allow_value(nil).for(:birth_date) }
  it { should_not allow_value(Date.today().to_s).for(:birth_date) }
  it { should_not allow_value('jfljdsfj').for(:birth_date) }

  context 'cpf' do
    it 'should be invalid if the cpf is invalid' do
      user_account = build :user_account, cpf: '1111111'
      expect(user_account.valid?).to be false
    end

    it 'should be valid if the cpf is valid' do
      user_account = build :user_account
      expect(user_account.valid?).to be true
    end

    it 'should remove cpf formatting' do
      user_account = create :user_account, cpf: '143.088.447-97'
      expect(user_account.cpf).equal?('14308844797')
    end
  end

  context 'referral_code' do
    it 'should create referral_code if the user_account status is complete' do
      user_account = create :user_account
      expect(user_account.referral_code).to eq(user_account.id[0..7])
    end

    it 'should not create referral_code if the user_account status is pending' do
      user_account = create :user_account, birth_date: nil
      expect(user_account.referral_code).to be_nil
    end
  end
end

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

require 'cpf_cnpj'

class UserAccount < ApplicationRecord
  validates :cpf, presence: true, uniqueness: true
  validate :valid_cpf

  after_create :create_referral_code

  enum status: [:pending, :complete]

  private

  def valid_cpf
    errors.add(:cpf, 'is not a valid CPF') unless CPF.valid?(cpf)
  end

  def create_referral_code
    self.update_attribute(:referral_code, self.id[0..7])
  end
end

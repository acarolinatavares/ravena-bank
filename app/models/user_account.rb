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

require 'cpf_cnpj'

class UserAccount < ApplicationRecord
  has_secure_password
  serialize :birth_date,  EncryptedCoder.new
  serialize :cpf,         EncryptedCoder.new
  serialize :email,       EncryptedCoder.new
  serialize :name,        EncryptedCoder.new

  validates :cpf, presence: true, uniqueness: true
  validate :valid_cpf
  validates :password, presence: true, length: {minimum: 6}
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i},
            uniqueness: {case_sensitive: false},
            allow_blank: true

  after_save :create_referral_code

  enum status: [:pending, :complete]

  private

  def valid_cpf
    errors.add(:cpf, 'is not a valid CPF') unless CPF.valid?(cpf)
  end

  def create_referral_code
    if self.complete? && self.referral_code.nil?
      self.update_attribute(:referral_code, self.id[0..7])
    end
  end
end

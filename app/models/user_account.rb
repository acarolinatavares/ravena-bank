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

require 'cpf_cnpj'

class UserAccount < ApplicationRecord
  has_secure_password
  serialize :birth_date,  EncryptedCoder.new
  serialize :cpf,         EncryptedCoder.new
  serialize :email,       EncryptedCoder.new
  serialize :name,        EncryptedCoder.new

  validates :cpf, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
            uniqueness: { case_sensitive: false },
            allow_blank: true
  validates :state, length: { is: 2 }, allow_blank: true
  validates :country, length: { is: 2 }, allow_blank: true
  validate :valid_cpf
  validate :valid_birth, if: -> { self.birth_date}

  before_validation :remove_cpf_formatting
  after_save :update_status_and_create_referral_code

  enum status: [:pending, :complete]

  private

  def valid_cpf
    errors.add(:cpf, 'is not a valid CPF') unless CPF.valid?(cpf)
  end

  def update_status_and_create_referral_code
    if empty_values?
      new_status = :pending
    else
      self.update_column(:referral_code, self.id[0..7]) if self.referral_code.nil?
      new_status = :complete
    end
    self.update_column(:status, new_status) if self.status != new_status
  end

  def valid_birth
    date = Date.parse(self.birth_date) rescue false
    errors.add(:birth_date, 'is not a valid birth_date') if !date || date >= Date.today
  end

  def remove_cpf_formatting
    document = CPF.new(cpf)
    self.cpf = document.stripped
  end

  def empty_values?
    self.attributes.any? do |k, v|
      %w[name email birth_date cpf gender city country state].include?(k) && v.blank?
    end
  end
end

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

require 'cpf_cnpj'

class UserAccount < ApplicationRecord
  validates :cpf, presence: true
  validate :valid_cpf

  private

  def valid_cpf
    errors.add(:cpf, 'is not a valid CPF') unless CPF.valid?(cpf)
  end
end

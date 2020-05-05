require 'rails_helper'

RSpec.describe 'UserAccounts', type: :request do
  PENDING_PARAMS = {
      name: 'Lawrence Marvin',
      email: 'homer@denesik.name',
      cpf: '81849699968',
      gender: 'F',
      city: 'Rio de Janeiro',
      state: 'RJ',
      country: 'BR',
      password: '123456'
  }

  COMPLETE_PARAMS = {
      name: 'Lawrence Marvin',
      email: 'homer@denesik.name',
      cpf: '81849699968',
      gender: 'F',
      city: 'Rio de Janeiro',
      state: 'RJ',
      country: 'BR',
      password: '123456',
      birth_date: '01/07/1991'
  }

  describe "POST create" do
    it 'must create a user_account with status PENDING' do
      post '/user_accounts', params: { user_account: PENDING_PARAMS }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).
          to eq('Account opening request made successfully. Status: Pending.')
    end

    it 'must create a user_account with status COMPLETE' do
      post '/user_accounts', params: { user_account: COMPLETE_PARAMS }

      user = UserAccount.find_by(cpf: '81849699968')

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).
          to eq('Account opening request made successfully. Status: Complete.')
      expect(JSON.parse(response.body)['referral_code']).
          to eq(user.referral_code[0..7])
    end

    it 'must require the password' do
      user = build :user_account
      post '/user_accounts', params: { user_account: { cpf: user.cpf } }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).
          to eq('The password is required.')
    end
  end
end

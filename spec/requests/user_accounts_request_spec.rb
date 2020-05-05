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

  WRONG_PARAMS = {
      name: 'Lawrence Marvin',
      email: 'djhfbkajsdhbfk',
      password: '123456'
  }

  describe "POST create" do
    it 'must return an error if tries to create a user_account with wrong params' do
      post '/user_accounts', params: { user_account: WRONG_PARAMS }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['message']).
          to eq('Error when trying to register account opening request.')
    end

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

    it 'must update an existing user_account' do
      user_account = UserAccount.new(cpf: '14308844797',
                                     password: '123456',
                                     password_confirmation: '123456')
      UserAccount::CreateOperation.new(user_account,
                                       {cpf: '14308844797', name: 'Ana Carolina'}
      ).process

      post '/user_accounts', params: { user_account:
                                           {
                                               cpf: '14308844797',
                                               password: '123456',
                                               birth_date: '01/07/1991'
                                           }
      }
      expect(response).to have_http_status(:ok)
    end

    it 'must throw an error if tries to create a user_account with a nonexistent referral_code' do
      post '/user_accounts', params: { user_account: {
          cpf: '14308844797',
          password: '123456',
          referral_code: '65398298'
      } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).
          to eq('The referral code does not belongs to any account.')
    end
  end

  describe 'auth' do
    it 'must require the correct password' do
      user_account = UserAccount.new(cpf: '14308844797',
                                     password: '123456',
                                     password_confirmation: '123456')
      UserAccount::CreateOperation.new(user_account,
                                       {cpf: '14308844797', name: 'Ana Carolina'}
      ).process

      post '/user_accounts', params: { user_account:
                                           {
                                               cpf: '14308844797',
                                               password: '76572524',
                                               birth_date: '01/07/1991'
                                           }
      }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('The password is wrong.')
    end

    it 'must require the password' do
      user = build :user_account
      post '/user_accounts', params: { user_account: { cpf: user.cpf } }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).
          to eq('The password is required.')
    end

    it 'must require the password' do
      user = build :user_account
      get '/user_accounts/list_indications', params: { user_account: { cpf: user.cpf } }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).
          to eq('The password is required.')
    end
  end

  describe 'GET list_indications' do
    it 'must return an error if tries to list indications of a pending account' do
      user_account = UserAccount.new(cpf: '14308844797',
                                     password: '123456',
                                     password_confirmation: '123456')
      UserAccount::CreateOperation.new(user_account,
                                       {cpf: '14308844797', name: 'Ana Carolina'}
      ).process

      get '/user_accounts/list_indications', params: {
          user_account: { cpf: '14308844797', password: '123456' }
      }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['errors']).
          to eq('This functionality is only intended for accounts with status complete.')
    end

    it 'must return the indications' do
      account = UserAccount.new(cpf: '81849699968',
                                     password: '123456',
                                     password_confirmation: '123456')
      UserAccount::CreateOperation.new(account, COMPLETE_PARAMS).process

      account = UserAccount.find_by(cpf: '81849699968')

      user_account = UserAccount.new(cpf: '14308844797',
                                     password: '654321',
                                     password_confirmation: '654321')
      UserAccount::CreateOperation.new(user_account,
                                       {cpf: '14308844797',
                                        name: 'Ana Carolina',
                                        referral_code: account.referral_code}
      ).process

      indicated_account = UserAccount.find_by(cpf: '14308844797')

      get '/user_accounts/list_indications', params: {
          user_account: { cpf: '81849699968', password: '123456' }
      }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['indications'].first["name"]).to eq(indicated_account.name)
    end
  end
end

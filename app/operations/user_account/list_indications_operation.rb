class UserAccount::ListIndicationsOperation
  attr_reader :json_response, :status
  def initialize(user_account)
    @user_account = user_account
  end

  def process
    if @user_account.id
      if @user_account.complete?
        indications = UserAccount.where(invitation_code: @user_account.referral_code)
        @json_response = { indications: indications.map do |indication|
          { id: indication.id, name: indication.name }
        end }
        @status = :ok
        return self
      end

      return_error('This functionality is only intended for accounts with complete status.')
      @status = :bad_request
      return self
    end

    return_error('Could not find an account with the given CPF.')
    @status = :not_found
    self
  end

  private

  def return_error(errors)
    @json_response = {
        message: 'Error trying to list indicated accounts.',
        errors: errors
    }
  end
end

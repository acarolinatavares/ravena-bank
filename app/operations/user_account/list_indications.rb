class UserAccount::ListIndicationsOperation
  attr_reader :json_response, :status
  def initialize(cpf)
    @user_account = UserAccount.find_by(cpf: cpf)
  end

  def process
    if @user_account
      if @user_account.complete?
        indications = UserAccount.where(invitation_code: @user_account.referral_code)
        @json_response = { indications: indications.map do |indication|
          { id: indication.id, name: indication.name }
        end }
        @status = :ok
        return
      end
      return_error('This functionality is only intended for accounts with complete status.')
      @status = :bad_request
      return
    end
    return_error('Could not find an account with the given CPF.')
    @status = :not_found
  end

  private

  def return_error(errors)
    @json_response = {
        message: 'Error trying to list indicated accounts.',
        errors: errors
    }
  end
end

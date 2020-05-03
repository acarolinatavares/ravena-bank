class UserAccount::CreateOperation
  attr_reader :json_response, :status
  def initialize(params)
    @user_account = UserAccount.find_or_initialize_by(params[:cpf])
  end

  def process
    @user_account.assign_attributes(params)
    @status = @user_account.id.nil? ? :created : :ok
    if @user_account.valid? && @user_account.save
      @json_response = { message: 'Account opening request made successfully. Status: Pending.' }
      if @user_account.attributes.values.include?(nil)
        @user_account.complete!
        @json_response = {
            message: 'Account opening request made successfully. Status: Complete.',
            referral_code: @user_account.referral_code
        }
      end
      return
    end

    @json_response = {
        message: 'Error when trying to register account opening request.',
        errors: @user_account.errors
    }
    @status = :bad_request
  end
end

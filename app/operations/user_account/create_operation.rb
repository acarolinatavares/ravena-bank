class UserAccount::CreateOperation
  attr_reader :json_response, :status
  def initialize(user_account, params)
    @params = params
    @user_account = user_account
  end

  def process
    if @params[:referral_code].present?
      return self unless check_referral_code
    end

    @user_account.assign_attributes(@params)
    @status = @user_account.id.nil? ? :created : :ok

    if @user_account.valid? && @user_account.save
      @json_response = { message: 'Account opening request made successfully. Status: Pending.' }
      if @user_account.complete?
        @json_response = {
            message: 'Account opening request made successfully. Status: Complete.',
            referral_code: @user_account.referral_code
        }
      end
      return self
    end

    return_error(@user_account.errors)
    self
  end

  private

  def check_referral_code
    if UserAccount.find_by(referral_code: @params[:referral_code])
      @params[:invitation_code] = @params[:referral_code]
      @params.delete(:referral_code)
      return true
    end
    return_error('The referral code does not belongs to any account.')
    false
  end

  def return_error(errors)
    @json_response = {
        message: 'Error when trying to register account opening request.',
        errors: errors
    }
    @status = :unprocessable_entity
  end
end

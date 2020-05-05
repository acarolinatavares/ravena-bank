class UserAccount::CreateOperation
  attr_reader :json_response, :status
  def initialize(params)
    @params = params
    @user_account = UserAccount.find_or_initialize_by(params[:cpf])
  end

  def process
    check_referral_code if @params[:referral_code].present?

    @user_account.assign_attributes(@params)
    @status = @user_account.id.nil? ? :created : :ok

    if @user_account.valid? && @user_account.save
      @json_response = { message: 'Account opening request made successfully. Status: Pending.' }
      update_account_status if @user_account.attributes.values.include?(nil)
      return
    end

    return_error(@user_account.errors)
  end

  private

  def update_account_status
    @user_account.complete!
    @json_response = {
        message: 'Account opening request made successfully. Status: Complete.',
        referral_code: @user_account.referral_code
    }
  end

  def check_referral_code
    if User.find_by(referral_code: @params[:referral_code])
      @params[:invitation_code] = @params[:referral_code]
      @params.delete(:referral_code)
    else
      return_error('The referral code does not belongs to any account.')
      nil
    end
  end

  def return_error(errors)
    @json_response = {
        message: 'Error when trying to register account opening request.',
        errors: errors
    }
    @status = :unprocessable_entity
  end
end

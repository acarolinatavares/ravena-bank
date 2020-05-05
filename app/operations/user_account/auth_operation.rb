class UserAccount::AuthOperation
  attr_reader :error_response, :user_account

  def initialize(params)
    @cpf = params[:cpf]
    @password = params[:password]
  end

  def process
    unless @password
      @error_response = 'The password is required.'
      return self
    end

    @user_account = UserAccount.find_or_initialize_by(cpf: @cpf)
    unless @user_account.id
      @user_account.password = @password
      @user_account.password_confirmation = @password
      return self
    end

    @error_response =  'The password is wrong.' unless @user_account.authenticate(@password)
    self
  end
end

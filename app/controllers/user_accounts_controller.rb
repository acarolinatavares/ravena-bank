class UserAccountsController < ApplicationController
  before_action :auth_user

  def create
    operation = UserAccount::CreateOperation.new(@user_account, user_account_params).process
    render json: operation.json_response, status: operation.status
  end

  def list_indications
    operation = UserAccount::ListIndicationsOperation.new(@user_account).process
    render json: operation.json_response, status: operation.status
  end

  private

  def user_account_params
    params.require(:user_account).permit(:birth_date, :city, :country, :cpf,
                                         :email, :gender, :name, :state, :referral_code)
  end

  def auth_user
    render(json: { error: 'The password is required.' }, status: :unauthorized) && (return) unless auth_params[:password]

    @user_account = UserAccount.find_or_initialize_by(cpf: auth_params[:cpf])
    unless @user_account.id
      @user_account.password = auth_params[:password]
      @user_account.password_confirmation = auth_params[:password]
      return
    end

    unless @user_account.authenticate(auth_params[:password])
      render json: { error: 'The password is wrong.' }, status: :unauthorized
    end
  end

  def auth_params
    params.permit(:cpf, :password)
  end
end

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
    operation = UserAccount::AuthOperation.new(auth_params).process
    render(json: { error: operation.error_response }, status: :unauthorized) && (return) if operation.error_response

    @user_account = operation.user_account
  end

  def auth_params
    params.permit(:cpf, :password)
  end
end

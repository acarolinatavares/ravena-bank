class UserAccountsController < ApplicationController
  def create
    operation = UserAccount::CreateOperation.new(user_account_params).process
    render json: operation.json_response, status: operation.status
  end

  private

  def user_account_params
    params.require(:user_account).permit(:birth_date, :city, :country, :cpf,
                                         :email, :gender, :name, :state)
  end
end

class AddInvitationCodeInUserAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :user_accounts, :invitation_code, :string
  end
end

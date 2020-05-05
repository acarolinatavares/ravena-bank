class AddPasswordDigestToUserAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :user_accounts, :password_digest, :string
  end
end

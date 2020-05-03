class AddStatusInUserAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :user_accounts, :status, :integer, default: 0
  end
end

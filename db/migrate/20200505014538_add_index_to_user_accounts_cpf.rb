class AddIndexToUserAccountsCpf < ActiveRecord::Migration[6.0]
  def change
    add_index :user_accounts, :cpf, unique: true
  end
end

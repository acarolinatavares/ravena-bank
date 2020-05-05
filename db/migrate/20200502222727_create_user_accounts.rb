class CreateUserAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_accounts, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :cpf, null: false
      t.string :birth_date
      t.string :gender
      t.string :city
      t.string :state, limit: 2
      t.string :country, limit: 2
      t.string :referral_code

      t.timestamps
    end
  end
end

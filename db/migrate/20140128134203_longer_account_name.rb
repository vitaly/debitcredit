class LongerAccountName < ActiveRecord::Migration[4.2]
  def up
    change_column :debitcredit_accounts, :name, :string, limit: 32, null: false
  end

  def down
    change_column :debitcredit_accounts, :name, :string, limit: 16, null: false
  end
end

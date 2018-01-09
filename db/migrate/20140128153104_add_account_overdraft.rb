class AddAccountOverdraft < ActiveRecord::Migration[4.2]
  def change
    add_column :debitcredit_accounts, :overdraft_enabled, :boolean, null: false, default: true
  end
end

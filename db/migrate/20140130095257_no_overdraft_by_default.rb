class NoOverdraftByDefault < ActiveRecord::Migration[4.2]
  def up
    change_column_default :debitcredit_accounts, :overdraft_enabled, false
  end

  def down
    change_column_default :debitcredit_accounts, :overdraft_enabled, true
  end
end

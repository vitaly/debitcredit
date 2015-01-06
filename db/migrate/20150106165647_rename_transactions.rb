class RenameTransactions < ActiveRecord::Migration
  def change
    rename_table :debitcredit_transactions, :debitcredit_entries
    rename_column :debitcredit_entries, :parent_transaction_id, :parent_entry_id
    rename_column :debitcredit_entries, :inverse_transaction_id, :inverse_entry_id

    rename_column :debitcredit_items, :transaction_id, :entry_id
  end
end

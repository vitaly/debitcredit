class AddTransactionParent < ActiveRecord::Migration
  def change
    add_column :debitcredit_entries, :parent_transaction_id, :integer
    add_index :debitcredit_entries, [:parent_transaction_id]
  end
end

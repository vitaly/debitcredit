class AddTransactionParent < ActiveRecord::Migration[4.2]
  def change
    add_column :debitcredit_transactions, :parent_transaction_id, :integer
    add_index :debitcredit_transactions, [:parent_transaction_id]
  end
end

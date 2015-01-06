class AddInverseTransactionId < ActiveRecord::Migration
  def change
    add_column :debitcredit_transactions, :inverse_transaction_id, :integer
  end
end

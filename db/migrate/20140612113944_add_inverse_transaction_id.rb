class AddInverseTransactionId < ActiveRecord::Migration
  def change
    add_column :debitcredit_entries, :inverse_entry_id, :integer
  end
end

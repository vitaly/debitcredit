class AddTransactionParent < ActiveRecord::Migration
  def change
    add_column :debitcredit_entries, :parent_entry_id, :integer
    add_index :debitcredit_entries, [:parent_entry_id]
  end
end

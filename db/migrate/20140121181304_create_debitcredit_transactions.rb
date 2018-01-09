class CreateDebitcreditTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :debitcredit_transactions do |t|
      t.integer :reference_id,   null: true
      t.string  :reference_type, null: true, limit: 32
      t.string  :kind,           null: true
      t.string  :description,    null: false

      t.timestamps
    end
    add_index :debitcredit_transactions, [:reference_id, :reference_type, :id], name: :rindex
  end
end

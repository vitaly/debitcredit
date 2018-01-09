class CreateDebitcreditAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :debitcredit_accounts do |t|
      t.string  :name,           null: false, limit:     16
      t.string  :type,           null: false, limit:     32
      t.integer :reference_id,   null: true
      t.string  :reference_type, null: true,  limit:     32
      t.decimal :balance,        null: false, precision: 20, scale: 2, default: 0

      t.timestamps
    end
    add_index :debitcredit_accounts, [:name, :reference_id, :reference_type], unique: true, name: :uindex
  end
end

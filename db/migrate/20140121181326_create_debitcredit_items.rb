class CreateDebitcreditItems < ActiveRecord::Migration
  def change
    create_table :debitcredit_items do |t|
      t.references :entry, null: false
      t.references :account,     null: false
      t.boolean    :debit,       null: false
      t.string     :comment,     null: true
      t.decimal    :amount,      null: false, precision: 20, scale: 2, default: 0
      t.decimal    :balance,     null: false, precision: 20, scale: 2, default: 0
      t.timestamps
    end
    add_index :debitcredit_items, :account_id
    add_index :debitcredit_items, :entry_id
  end
end

include Debitcredit

Account.count
Entry.build do
  debit Account.first, 12.34, 'test 123'
end

Account.transaction do
  Account.order(:id).lock.first
end

AssetAccount.sum(:balance)


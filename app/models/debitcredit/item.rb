module Debitcredit
  class Item < ActiveRecord::Base
    belongs_to :transaction
    belongs_to :account

    validate :references, :account, presence: true
    validate :amount, numericality: true, greater_than_or_equal_to: 0

    private

    def kind
      debit?? :debit : :credit
    end

    def update_balance
      self.balance = account.send(kind, amount)
    end
  end
end

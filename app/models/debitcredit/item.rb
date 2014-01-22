module Debitcredit
  class Item < ActiveRecord::Base
    belongs_to :transaction
    belongs_to :account

    validate :transaction, :account, presence: true
    validate :amount, numericality: true, greater_than_or_equal_to: 0

    scope :debit, ->{where(debit: true)}
    scope :credit, ->{where(debit: false)}

    def credit?
      !debit?
    end

    def value_for_balance
      credit?? amount : -amount
    end

    private

    def kind
      debit?? :debit : :credit
    end

    def update_balance
      self.balance = account.send(kind, amount)
    end
  end
end

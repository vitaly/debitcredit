module Debitcredit
  class CreditAccount < Account
    def debit(amount)
      self.balance -= amount
    end

    def credit(amount)
      self.balance += amount
    end
  end
end

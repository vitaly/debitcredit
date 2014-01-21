module Debitcredit
  class DebitAccount < Account
    def debit(amount)
      self.balance += amount
    end

    def credit(amount)
      self.balance -= amount
    end
  end
end

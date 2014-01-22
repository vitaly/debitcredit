class Debitcredit::Transaction::DSL
  attr_accessor :transaction
  def initialize(transaction)
    @transaction = transaction
    @accounts = {}
  end

  def debit(account, amount, comment = nil)
    build_item true, account, amount, comment
  end

  def creidit(account, amount, comment = nil)
    build_item false, account, amount, comment
  end

  def execute!
    lock_accounts!
    transaction.save!
    save_accounts!
  end

  private
  def build_item(debit, account, amount, comment)
    transaction.items.build debit: debit, account: _account(account), amount: amount, comment: comment
  end

  def _account(account)
    @accounts[account.id] ||= account
  end

  def lock_accounts!
    @accounts.keys.sort.each do |k|
      @accounts[k].lock!
    end
  end

  def save_accounts!
    @accounts.values.each(&:save!)
  end
end

class Debitcredit::Transaction::Dsl
  attr_accessor :transaction
  attr_accessor :accounts

  def initialize(transaction)
    @transaction = transaction
  end

  def kind(kind)
    @transaction.kind = kind
  end

  def description(desc)
    @transaction.description = desc
  end
  alias desc description

  def reference(ref)
    @transaction.reference = ref
  end
  alias ref reference

  def debit(account, amount, comment = nil)
    build_item true, account, amount, comment
  end

  def credit(account, amount, comment = nil)
    build_item false, account, amount, comment
  end

  private
  def build_item(debit, account, amount, comment)
    account = transaction.reference.accounts[account] if account.is_a?(Symbol) && transaction.reference.try(:respond_to?, :accounts)
    transaction.items.build debit: debit, account: account, amount: amount, comment: comment
  end
end

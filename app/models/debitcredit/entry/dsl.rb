class Debitcredit::Entry::Dsl
  attr_accessor :entry
  attr_accessor :accounts

  def initialize(entry)
    @entry = entry
  end

  def kind(kind)
    @entry.kind = kind
  end

  def description(desc)
    @entry.description = desc
  end
  alias desc description

  def reference(ref)
    @entry.reference = ref
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
    account = entry.reference.accounts[account] if account.is_a?(Symbol) && entry.reference.try(:respond_to?, :accounts)
    entry.items.build debit: debit, account: account, amount: amount, comment: comment
  end
end

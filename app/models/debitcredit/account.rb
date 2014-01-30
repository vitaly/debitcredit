module Debitcredit
  class Account < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy

    validates :name, :balance, presence: true
    validate :prevent_overdraft, unless: :overdraft_enabled?

    scope :asset,     ->{where(type: AssetAccount.name)}
    scope :equity,    ->{where(type: EquityAccount.name)}
    scope :liability, ->{where(type: LiabilityAccount.name)}
    scope :expense,   ->{where(type: ExpenseAccount.name)}
    scope :income,    ->{where(type: IncomeAccount.name)}

    scope :by_id, ->{order(:id)}

    class << self
      def [](name)
        find_by!(name: name)
      end

      def total_balance
        + asset.sum(:balance) \
        + expense.sum(:balance) \
        - liability.sum(:balance) \
        - equity.sum(:balance) \
        - income.sum(:balance)
      end

      def balanced?
        transaction do
          by_id.lock.first
          0 == total_balance
        end
      end
    end

    attr_accessor :check_overdraft
    def update_balance!(item, check_overdraft = true)
      item.balance = send(item.kind, item.amount)
      self.check_overdraft = check_overdraft
      save!
    end

    def overdraft?
      balance < 0
    end

    protected

    def prevent_overdraft
      return unless balance_changed?
      return unless check_overdraft
      return unless balance < 0
      return unless balance_was > balance

      errors.add(:balance, :overdraft)
    end
  end
end

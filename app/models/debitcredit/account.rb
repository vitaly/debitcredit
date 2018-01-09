require 'docile'
module Debitcredit
  class Account < ApplicationRecord
    belongs_to :reference, polymorphic: true, optional: true
    has_many :items, dependent: :destroy

    validates :name, :balance, presence: true
    validate :prevent_overdraft, unless: :overdraft_enabled?

    scope :asset,     ->{where(type: AssetAccount.name)}
    scope :equity,    ->{where(type: EquityAccount.name)}
    scope :liability, ->{where(type: LiabilityAccount.name)}
    scope :expense,   ->{where(type: ExpenseAccount.name)}
    scope :income,    ->{where(type: IncomeAccount.name)}

    scope :by_id, ->{order(:id)}

    class NotFound < StandardError; end
    class BadKind < StandardError; end
    class << self
      def by_kind kind
        Debitcredit.const_get "#{kind.to_s.capitalize}Account"
      end

      def find_or_create(name, kind = nil, overdraft = false)

        unless account = find_by(name: name)
          # Note: reference is automatically provided by association
          # when running through an association, e.g. @user.accounts[ .... ]
          raise NotFound, "account #{name} not found. Provide kind to create a new one" unless kind

          return by_kind(kind).create!(
            name: name.to_s,
            overdraft_enabled: overdraft
          )
        end

        raise BadKind if kind && by_kind(kind) != account.class

        if overdraft != account.overdraft_enabled?
          account.update_attributes! overdraft_enabled: overdraft
        end

        return account
      end
      alias :[] :find_or_create

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

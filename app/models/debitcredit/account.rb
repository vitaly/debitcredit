module Debitcredit
  class Account < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy

    validates :name, :balance, presence: true

    scope :by_id, ->{order(:id)}

    class << self
      def [](name)
        find_by!(name: name)
      end

      def total_balance
        + AssetAccount.sum(:balance) \
        + ExpenseAccount.sum(:balance) \
        - LiabilityAccount.sum(:balance) \
        - EquityAccount.sum(:balance) \
        - IncomeAccount.sum(:balance)
      end

      def balanced?
        transaction do
          by_id.lock.first
          0 == total_balance
        end
      end
    end

    def update_balance!(item)
      item.balance = send(item.kind, item.amount)
      save!
    end
  end
end

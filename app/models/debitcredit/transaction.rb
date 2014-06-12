require 'docile'
module Debitcredit
  class Transaction < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    belongs_to :parent_transaction, class_name: 'Debitcredit::Transaction'
    belongs_to :inverse_transaction, class_name: 'Debitcredit::Transaction'
    has_many :items, dependent: :destroy, autosave: true

    validates :reference, :description, presence: true
    validate :ensure_balanced

    validate :parent_not_inversed, if: :is_inverse

    before_create :lock_and_update_balances
    after_save :save_parent

    def self.prepare(opts = {}, &block)
      new(opts).tap do |t|
        Docile.dsl_eval(Dsl.new(t), &block)
      end
    end

    attr_accessor :is_inverse
    attr_accessor :ignore_overdraft

    def inverse(opts = {})
      self.class.new({ignore_overdraft: true, is_inverse: true}.merge(opts)) do |res|
        res.items = items.map(&:inverse)
        res.description ||= "reverse of tr ##{id}: #{description}"
        res.kind ||= 'rollback'
        res.reference ||= reference
        res.parent_transaction = self
        self.inverse_transaction ||= res
      end
    end

    def items_balance
      items.map(&:value_for_balance).sum
    end

    def balanced?
      items_balance.zero?
    end

    protected

    def ensure_balanced
      errors.add(:base, :unbalanced) unless balanced?
    end

    def lock_and_update_balances
      items.sort_by(&:account_id).each do |item|
        item.account.lock!.update_balance!(item, !ignore_overdraft)
      end
    end

    def save_parent
      parent_transaction.save! if parent_transaction.try(:inverse_transaction) == self
    end

    def parent_not_inversed
      errors.add(:base, :already_inversed) if parent_transaction.inverse_transaction_id
    end
  end
end

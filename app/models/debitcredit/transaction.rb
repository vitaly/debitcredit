require 'docile'
module Debitcredit
  class Transaction < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    belongs_to :parent_transaction, class_name: 'Debitcredit::Transaction'
    has_many :items, dependent: :destroy, autosave: true

    validates :reference, :description, presence: true
    validate :ensure_balanced

    before_create :lock_and_update_balances

    def self.prepare(opts = {}, &block)
      new(opts).tap do |t|
        Docile.dsl_eval(Dsl.new(t), &block)
      end
    end

    attr_accessor :ignore_overdraft
    def inverse(opts = {})
      self.class.new({ignore_overdraft: true}.merge(opts)) do |res|
        res.items = items.map(&:inverse)
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
  end
end

require 'docile'
module Debitcredit
  class Transaction < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy, autosave: true

    validates :reference, :description, presence: true
    validate :ensure_balanced

    before_create :lock_and_update_balances

    # XXX
    # prevent items and balance changes on update
    # prevent update at all?

    def self.prepare(opts = {}, &block)
      new(opts).tap do |t|
        Docile.dsl_eval(DSL.new(t), &block)
      end
    end

    def items_balance
      items.map(&:value_for_balance).sum
    end

    def balanced?
      0 == items_balance
    end

    protected
    def ensure_balanced
      errors.add(:base, :unbalanced) unless balanced?
    end

    def lock_and_update_balances
      items.sort_by(&:account_id).each do |item|
        item.account.lock!.update_balance!(item)
      end
    end
  end
end

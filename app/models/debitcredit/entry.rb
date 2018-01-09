require 'docile'
module Debitcredit
  class Entry < ApplicationRecord
    belongs_to :reference, polymorphic: true, optional: true
    belongs_to :parent_entry, class_name: 'Debitcredit::Entry', optional: true
    has_many :child_entries, class_name: 'Debitcredit::Entry', foreign_key: 'parent_entry_id'
    belongs_to :inverse_entry, class_name: 'Debitcredit::Entry', optional: true
    has_many :items, dependent: :destroy, autosave: true, inverse_of: :entry

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
        res.parent_entry = self
        self.inverse_entry ||= res
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
      parent_entry.save! if parent_entry.try(:inverse_entry) == self
    end

    def parent_not_inversed
      errors.add(:base, :already_inversed) if parent_entry.inverse_entry_id
    end
  end
end

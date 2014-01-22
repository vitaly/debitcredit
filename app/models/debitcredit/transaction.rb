require 'docile'
module Debitcredit
  class Transaction < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy, autosave: true, validate: true

    validates :reference, :description, presence: true
    validate :ensure_balanced

    def self.build(opts = {}, &block)
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

    def ensure_balanced
      errors.add(:base, :unbalanced) unless balanced?
    end
  end
end

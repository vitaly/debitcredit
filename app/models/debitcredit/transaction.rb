require 'docile'
module Debitcredit
  class Transaction < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy, autosave: true, validate: true

    validate :reference, :description, presence: true

    def self.execute(opts = {}, &block)
      tr = new(opts)
      builder = Debitcredit::Transaction::DSL.new(tr)
      Docile.dsl_eval(builder, &block).execute!
    end
  end
end

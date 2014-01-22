module Debitcredit
  class Account < ActiveRecord::Base
    belongs_to :reference, polymorphic: true
    has_many :items, dependent: :destroy

    validates :name, :balance, presence: true

    class << self
      def [](name)
        find_by!(name: name)
      end

      def balanced?
        true
      end
    end
  end
end

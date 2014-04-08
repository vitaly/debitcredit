module Debitcredit
  module Extension
    extend ActiveSupport::Concern
    module ProxyMethods
      [:asset, :liability, :expense].each do |kind|
        define_method kind do |name, overdraft = false|
          define_method name do
            self[name, kind, overdraft]
          end
        end
      end
    end
    module ClassMethods
      def has_accounts(&block)
        has_many :accounts, as: :reference, class_name: 'Debitcredit::Account', inverse_of: :reference do
          extend ProxyMethods
          instance_eval &block
        end
      end

      def has_transactions &block
        has_many :transactions, as: :reference, class_name: 'Debitcredit::Transaction', &block
      end
    end
  end
end

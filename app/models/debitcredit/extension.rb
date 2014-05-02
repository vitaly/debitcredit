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
          class_eval(&block) if block
        end
      end

      def has_entries(&block)
        has_many :entries, as: :reference, class_name: 'Debitcredit::Entry' do
          def [](kind)
            find_by kind: kind
          end
          class_eval(&block) if block
        end
      end
    end
  end
end

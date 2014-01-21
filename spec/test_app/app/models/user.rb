class User < ActiveRecord::Base
  has_many :accounts, as: :reference, class_name: 'Debitcredit::Account'
  has_many :transactions, as: :reference, class_name: 'Debitcredit::Transaction'
end

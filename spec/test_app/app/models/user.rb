class User < ActiveRecord::Base
  include Debitcredit::Extension

  has_accounts do
    asset :balance
  end

  has_transactions

end

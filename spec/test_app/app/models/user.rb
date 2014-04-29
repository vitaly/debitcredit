class User < ActiveRecord::Base
  include Debitcredit::Extension

  has_accounts do
    asset :cash
  end

  has_transactions

end

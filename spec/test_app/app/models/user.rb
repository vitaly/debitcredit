class User < ActiveRecord::Base
  include Debitcredit::Extension

  has_accounts do
    asset :cash

    def accounts_method
      :ok
    end
  end

  has_transactions do
    def transactions_method
      :ok
    end
  end
end

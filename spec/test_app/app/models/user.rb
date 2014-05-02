class User < ActiveRecord::Base
  include Debitcredit::Extension

  has_accounts do
    asset :cash

    def accounts_method
      :ok
    end
  end

  has_entries do
    def entries_method
      :ok
    end
  end
end

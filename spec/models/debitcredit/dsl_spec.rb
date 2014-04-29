require 'spec_helper'

module Debitcredit
  describe 'DSL' do
    describe :has_accounts do
      it 'should define methods that create accounts' do
        acc = @john.accounts.cash
        expect(acc.class).to eq AssetAccount
        expect(acc).to eq @john.accounts[:cash]
      end
    end
    describe :has_transactions do
      it 'should define []' do
        expect(@john.transactions[:purchase]).to eq @laptop_purchase
      end
    end
  end
end

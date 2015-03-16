require 'spec_helper'

module Debitcredit
  describe Extension do
    describe 'has_accounts' do
      it 'should define methods that create accounts' do
        acc = @john.accounts.cash
        expect(acc.class).to eq AssetAccount
        expect(acc).to eq @john.accounts[:cash]
      end

      it 'should allow defining methods' do
        expect(@john.accounts.accounts_method).to eq :ok
      end
    end

    describe 'has_entries' do
      it 'should define []' do
        expect(@john.entries[:purchase]).to eq @laptop_purchase
      end

      it 'should allow defining methods' do
        expect(@john.entries.entries_method).to eq :ok
      end
    end
  end
end

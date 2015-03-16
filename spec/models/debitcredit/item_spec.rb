require 'spec_helper'

module Debitcredit
  describe Item do
    include_examples :valid_fixtures
    def valid_attrs; {entry: @laptop_purchase, account: @equipment, debit: true, amount: 10} end

    describe '.inverse' do
      it 'should not change record' do
        record.save!
        record.inverse
        expect(record).to_not be_changed
      end

      it 'should retain account' do
        expect(record.inverse.account).to eq record.account
      end

      it 'should retain entry' do
        expect(record.inverse.entry).to eq record.entry
      end

      it 'should retain amount' do
        expect(record.inverse.amount).to eq record.amount
      end

      it 'should invert kind' do
        expect(_record(debit: true).inverse).to be_credit
        expect(_record(debit: false).inverse).to be_debit
      end
    end
  end
end

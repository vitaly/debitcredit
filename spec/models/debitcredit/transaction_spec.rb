require 'spec_helper'

module Debitcredit
  describe Transaction do
    def valid_attrs
      {description: 'something', reference: @john}
    end

    def prepare(opts = {}, &b)
      @r = Transaction.prepare(valid_attrs.merge(opts), &b)
    end

    describe :validations do
      include_examples :valid_fixtures
      it 'should be valid with balanced items' do
        t = prepare do
          credit @bank, 100
          credit @amex, 1_000
          debit @rent, 1_100
        end
        expect(t).to be_balanced
        expect(t).to be_valid
      end

      it 'should not be valid with unbalanced items' do
        t = prepare do
          credit @amex, 1_000
          debit @rent, 999
        end
        expect(t).to_not be_balanced
        expect(t).to_not be_valid
      end

      it 'should lock and update account balances after validation' do
        expect(@equipment.balance).to eq(10_000)
        expect(@bank.balance).to eq(100_000)
        expect(@amex.balance).to eq(10_000)
        @amex2 = Account[:amex]
        expect(@amex2.balance).to eq(10_000)

        t = prepare do
          debit @equipment, 1_100
          credit @bank, 1_000
          credit @amex, 50
          credit @amex2, 50
        end

        expect(t).to be_valid
        t.save!

        expect(@equipment.reload.balance).to eq(11_100)
        expect(@bank.reload.balance).to eq(99_000)
        expect(@amex.balance).to eq(10_050)
        expect(@amex.reload.balance).to eq(10_100)
        expect(@amex2.reload.balance).to eq(10_100)
      end
    end

  end
end

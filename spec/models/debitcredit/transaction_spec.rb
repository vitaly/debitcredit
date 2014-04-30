require 'spec_helper'

module Debitcredit
  describe Transaction do
    def valid_attrs
      {description: 'something', reference: @john}
    end

    let(:transaction) {@laptop_purchase}

    def prepare(opts = {}, &b)
      @r = Transaction.prepare(valid_attrs.merge(opts), &b)
    end

    describe :validations do
      include_examples :valid_fixtures

      it 'should set kind' do
        t = prepare do
          kind 'foo'
        end

        expect(t.kind).to eq 'foo'
      end

      it 'should set description' do
        t = prepare do
          description 'bar'
        end

        expect(t.description).to eq 'bar'
      end

      it 'should set alias description' do
        t = prepare do
          desc 'baz'
        end

        expect(t.description).to eq 'baz'
      end

      it 'should set reference' do
        t = prepare do
          reference @bill
        end

        expect(t.reference).to eq @bill
      end

      it 'should alias reference' do
        t = prepare do
          ref @bill
        end

        expect(t.reference).to eq @bill
      end

      it 'should be valid with balanced items' do
        t = prepare do
          credit @bank, 100
          credit @amex, 1_000
          debit  @rent, 1_100
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
        @amex2 = Account[:amex]

        expect(@equipment.balance).to eq 10_000
        expect(@bank.balance).to      eq 100_000
        expect(@amex.balance).to      eq 10_000
        expect(@amex2.balance).to     eq 10_000

        t = prepare do
          debit  @equipment, 1_100
          credit @bank,      1_000
          credit @amex,      50
          credit @amex2,     50
        end

        expect(t).to be_valid
        t.save!

        expect(@equipment.reload.balance).to eq 11_100
        expect(@bank.reload.balance).to      eq 99_000
        expect(@amex.balance).to             eq 10_050
        expect(@amex.reload.balance).to      eq 10_100
        expect(@amex2.reload.balance).to     eq 10_100
      end

      it 'should fail to overdraft' do
        t = prepare do
          credit @bank, 100_000.1
          debit @equipment, 100_000.1
        end
        expect {
          t.save!
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe :prepare do
      it 'should allow using symbols for accounts' do
        t = @john.transactions.prepare do
          debit :equipment, 100
          credit :bank, 100
        end
        expect(t.items.map(&:account)).to eq [@equipment, @bank]
      end
    end

    describe :inverse do
      it 'should take description and kind' do
        inverse = transaction.inverse(description: 'foo', kind: 'rollback')
        expect(inverse.description).to eq 'foo'
        expect(inverse.kind).to eq 'rollback'
      end

      it 'should have inverted items' do
        expect(transaction.items.sort_by(&:kind).map(&:account)).to eq [@amex, @equipment]
        expect(transaction.inverse.items.sort_by(&:kind).map(&:account)).to eq [@equipment, @amex]
      end

      it 'should set ignore_overdraft to true' do
        expect(transaction.ignore_overdraft).to be_false
        expect(transaction.inverse.ignore_overdraft).to be_true
      end
    end
  end
end

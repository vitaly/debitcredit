require 'spec_helper'

module Debitcredit
  describe Account do
    def described_class; Debitcredit::AssetAccount; end
    def valid_attrs
      {name: 'foo'}
    end
    describe :validations do
      include_examples :valid_fixtures

      context 'when overdraft disabled' do
        def extra_attrs; {overdraft_enabled: false} end

        it 'should prevent negative balance' do
          record.save!
          record.check_overdraft = true
          record.balance = -1
          expect(record).to_not be_valid
          expect(record.errors[:balance]).to_not be_blank
        end

        it 'should ignore overdraft when check_overdraft is false' do
          record.save!
          record.balance = -1
          expect(record).to be_valid
        end

        it 'should allow keeping negative balance' do
          record(balance: -10).save
          record.check_overdraft = true
          expect(record).to be_valid
        end

        it 'should allow + on negative balance' do
          record(balance: -10).save
          record.check_overdraft = true
          record.balance = -5
          expect(record).to be_valid
        end

        it 'should allow - on positive balance' do
          record(balance: 10).save
          record.check_overdraft = true
          record.balance = 5
          expect(record).to be_valid
        end
      end

      context 'when overdraft enabled' do
        def extra_attrs; {overdraft_enabled: true} end

        it 'should allow negative balance in case of overdraft_enabled? = true' do
          record.save!
          record.balance = -1
          expect(record).to be_valid
          expect(record.errors[:balance]).to be_blank
        end
      end

    end

    describe :[] do
      it 'should find account by name' do
        expect(Account[:amex]).to eq(@amex)
      end

      it 'should raise on fail' do
        expect {
          Account[:foo]
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe :balanced? do
      it 'should initially be true' do
        expect(Account).to be_balanced
      end

      it 'should be false if out of balance' do
        @equipment.balance += 1
        @equipment.save!
        expect(Account).to_not be_balanced
      end

      it 'A + Ex = L + E + I' do # 5 + 9 = 2 + 4 + 8
        @equipment.balance += 5
        @equipment.save!

        @rent.balance += 9
        @rent.save!

        @amex.balance += 2
        @amex.save!

        @capital.balance += 4
        @capital.save!

        @salary.balance += 8
        @salary.save!

        expect(Account).to be_balanced
      end
    end
  end
end

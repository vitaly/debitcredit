require 'spec_helper'

module Debitcredit
  describe Account do
    include_examples :valid_fixtures

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
    end
  end
end

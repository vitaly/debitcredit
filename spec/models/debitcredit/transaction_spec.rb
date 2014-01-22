require 'spec_helper'

module Debitcredit
  describe Transaction do
    def valid_attrs
      {description: 'something', reference: @john}
    end

    def build(opts = {}, &b)
      @r = Transaction.build(valid_attrs.merge(opts), &b)
    end

    describe :validations do
      include_examples :valid_fixtures
      it 'should be valid with balanced items' do
        t = build do
          credit @bank, 100
          credit @amex, 1_000
          debit @rent, 1_100
        end
        expect(t).to be_balanced
        expect(t).to be_valid
      end

      it 'should not be valid with unbalanced items' do
        t = build do
          credit @amex, 1_000
          debit @rent, 999
        end
        expect(t).to_not be_balanced
        expect(t).to_not be_valid
      end
    end
  end
end

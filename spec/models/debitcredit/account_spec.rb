require 'spec_helper'

module Debitcredit
  describe Account do
    include_examples :valid_fixtures

    it 'shold be balanced' do
      #Account.should be_balanced
    end
  end
end

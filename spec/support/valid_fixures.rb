module ValidFixturesExample
  shared_examples :valid_fixtures do |n|
    it 'should have valid fixtures' do
      described_class.count.should == n if n
      described_class.find_each {|du| du.should be_valid}
    end
  end
end

RSpec.configure do |config|
  config.include ValidFixturesExample, type: :model
end


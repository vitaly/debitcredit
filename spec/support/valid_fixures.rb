module ValidFixturesExample
  RSpec.shared_examples :valid_fixtures do |n|
    it 'should have valid fixtures' do
      expect(described_class.count).to eq(n) if n
      described_class.find_each {|du| expect(du).to be_valid}
    end
  end
end

RSpec.configure do |config|
  config.include ValidFixturesExample, type: :model
end


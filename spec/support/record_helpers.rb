module RecordHelpers
  def _record(attrs = {})
    described_class.new(valid_attrs.merge(attrs))
  end

  def record(attrs = {})
    @r ||= _record(attrs)
  end
end

RSpec.configure do |config|
  config.include RecordHelpers
end

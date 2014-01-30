module RecordHelpers
  def record_class; described_class; end

  def _record(o = {})
    attrs = valid_attrs
    attrs = attrs.merge(extra_attrs) if respond_to?(:extra_attrs)
    record_class.new(attrs.merge(o))
  end

  def record(attrs = {})
    @r ||= _record(attrs)
  end
end

RSpec.configure do |config|
  config.include RecordHelpers
end

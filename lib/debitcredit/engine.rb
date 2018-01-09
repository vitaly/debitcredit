module Debitcredit
  class Engine < ::Rails::Engine
    isolate_namespace Debitcredit
    config.generators do |g|
      g.api_only = true
      g.test_framework :rspec
    end
  end
end

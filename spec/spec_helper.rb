# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'spork'

Spork.prefork do

  require File.expand_path("../test_app/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  ENGINE_RAILS_ROOT = File.expand_path('../..', __FILE__)

  # Shared connection support (for capybara and friends)
  # This enables using transactional fixtures with capybara
  # w/o this, Capybara will use it's own db connection, which is outside of transaction
  class ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil

    def self.connection
      @@shared_connection || retrieve_connection
    end
  end

  # Forces all threads to share the same connection. This works on
  # Capybara because it starts the web server in a thread.
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

  RSpec.configure do |config|
    config.expect_with :rspec do |c|
      c.syntax = :expect
    end

    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = File.join(ENGINE_RAILS_ROOT, "/spec/fixtures")

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures = true
    config.global_fixtures = :all

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    config.before :each do
      #Timecop.return
    end
  end

  ActiveRecord::Base.remove_connection if Spork.using_spork?
end

Spork.each_run do
  Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each { |f| load f }

  if Spork.using_spork?
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.retrieve_connection
    I18n.reload!
  end
end

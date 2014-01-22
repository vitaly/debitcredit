guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :rspec,
  cmd: "rspec --drb --format d",
  failed_mode: :focus,
  all_after_pass: false,
  all_on_start: false do

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
end

guard 'spork', cucumber: false, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

require "bundler/setup"
require "rubijan"
require "rubijan/yaku_identifier"
require "rubijan/yaku/seven_pairs"
require "rubijan/yaku/thirteen_orphans"
require "rubijan/errors"
require "rubijan/version"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

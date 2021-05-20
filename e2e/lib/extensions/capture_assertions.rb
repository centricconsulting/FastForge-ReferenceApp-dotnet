# frozen_string_literal: true

# Extending the RSpec module
module RSpec
  # Used to wrap multiple assertions in a block so we can validate them all before
  # raising an error.
  def self.capture_assertions(msg = 'One or more assertions failed.')
    failures = []
    # rubocop:disable Style/Lambda
    failure_notifier = lambda { |failure, _opts| failures << failure }
    # rubocop:enable Style/Lambda
    old_failure_notifier = RSpec::Support.failure_notifier
    RSpec::Support.failure_notifier = failure_notifier
    yield
    RSpec::Support.failure_notifier = old_failure_notifier
    raise RSpec::Expectations::ExpectationNotMetError, "#{msg}\nFailures: #{failures.join("\n")}" unless failures.count.zero?
  end
end

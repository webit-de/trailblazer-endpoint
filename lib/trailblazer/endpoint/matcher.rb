require "dry/matcher"

# if you want to have your custom matchers
# just implement self.match_cases in your Matcher subclass
class Trailblazer::Endpoint::Matcher
  def self.build_matcher
    Dry::Matcher.new(
      match_cases.transform_values do |value|
        if value.is_a?(Dry::Matcher::Case)
          value
        else
          Dry::Matcher::Case.new(match: value)
        end
      end
    )
  end

  class Default < Trailblazer::Endpoint::Matcher
    # these are the default match_cases
    def self.match_cases
      {
        present: ->(result) { result.success? && result["present"] }, # DISCUSS: the "present" flag needs some discussion.
        success: ->(result) { result.success? },
        created: ->(result) { result.success? && result["model.action"] == :new }, # the "model.action" doesn't mean you need Model.
        not_found: ->(result) { result.failure? && result["result.model"] && result["result.model"].failure? },
        # TODO: we could add unauthorized here.
        unauthenticated: ->(result) { result.failure? && result["result.policy.default"].failure? }, # FIXME: we might need a &. here ;)
        invalid: ->(result) { result.failure? && result["result.contract.default"] && result["result.contract.default"].failure? }
      }
    end
  end
end

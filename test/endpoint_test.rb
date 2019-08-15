require "test_helper"
#require 'pry'

class EndpointTest < Minitest::Spec
  Song = Struct.new(:id, :title, :length) do
    def self.find_by(id:nil); id.nil? ? nil : new(id) end
  end

  class Unauthenticated < Trailblazer::Operation
    class ResultMatcher < Trailblazer::Endpoint::Matcher::Default
      def self.match_cases
        super.slice(:success, :unauthenticated)
      end
    end

    step Policy::Guard ->(*, user: nil, **) { user == :foo }
  end

  let(:custom_handler) {
    ->(m) {
      m.not_found       { |result| 'not found' }
      m.unauthenticated { |result| 'unauthenticated' }
      m.present         { |result| 'present' }
      m.created         { |result| 'created' }
      m.success         { |result| 'success' }
      m.invalid         { |result| 'invalid' }
    }
  }

  describe "with default matchers" do
    it "works with custom handlers" do
      endpoint = Trailblazer::Endpoint.new(handler: custom_handler)

      result = Unauthenticated.(user: :bar)
      endpoint.(result).must_equal 'unauthenticated'

      result = Unauthenticated.(user: :foo)
      endpoint.(result).must_equal 'success'
    end

    it "can override custom handlers" do
      endpoint = Trailblazer::Endpoint.new(handler: custom_handler)

      result = Unauthenticated.(user: :bar)
      endpoint.(result) do |m|
        m.success { |result| 'supergeil' }
      end.must_equal 'unauthenticated'

      result = Unauthenticated.(user: :foo)
      endpoint.(result) do |m|
        m.success { |result| 'supergeil' }
      end.must_equal 'supergeil'
    end
  end

  describe "with custom matchers" do
    it "handles default unauthenticated" do
      result = Unauthenticated.(user: :bar)
      Trailblazer::Endpoint.new(matcher_class: Unauthenticated::ResultMatcher).(result) do |m|
        m.success { |_res| 'yippieh' }
        m.unauthenticated { |_res| 'not foo' }
      end.must_equal('not foo')
    end
  end

end

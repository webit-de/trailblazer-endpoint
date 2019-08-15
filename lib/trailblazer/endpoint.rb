module Trailblazer
  class Endpoint

    attr_reader :matcher, :handler

    # `call`s the operation.
    def self.call(operation_class, args: {}, **options, &block)
      result = operation_class.(args)
      new(options.slice(:handler, :matcher_class)).(result, &block)
    end

    def initialize(handler: nil, matcher_class: Matcher::Default)
      @handler = handler
      @matcher = matcher_class.build_matcher
    end

    def call(result, &block)
      matcher.(result) do |m|
        yield(m) if block_given? # evaluate user blocks first
        handler.call(m) if handler # then, generic handler
      end
    end

    module Controller
      # endpoint(Create) do |m|
      #   m.not_found { |result| .. }
      # end
      def endpoint(operation_class, **options, &block)
        options[:handler] ||= Handler::Rails.new(self, options)
        Endpoint.(operation_class, options, &block)
      end
    end
  end
end

require 'trailblazer/endpoint/matcher'

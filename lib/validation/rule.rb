module Validation
  module Rule
    attr_reader :field, :options

    def initialize(field, options = {})
      @field = field.to_sym
      defaults = self.class.default_options
      defaults = defaults.respond_to?(:call) ? defaults.call : defaults
      @options = defaults.merge(options)
    end

    def rule_id
      self.class.rule_id
    end

    def blank?(value)
      return value.empty? || /\A[[:space:]]*\z/.match(value) if value.is_a?(String)
      value.respond_to?(:empty?) ? !!value.empty? : !value
    end

    private

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def rule_id(value = nil)
        return @rule_id unless value
        @rule_id = value.to_sym
      end

      def default_options(value = nil)
        return @default_options unless value
        @default_options = value
      end
    end
  end
end

require_relative 'rule/email'
require_relative 'rule/length'
require_relative 'rule/matches'
require_relative 'rule/not_empty'
require_relative 'rule/numeric'
require_relative 'rule/phone'
require_relative 'rule/regex'
require_relative 'rule/uri'
require_relative 'rule/uuid'
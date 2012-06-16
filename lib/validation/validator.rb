module Validation
  module Rules
    def rules
      @rules ||= {}
    end

    def errors
      @errors ||= {}
    end

    def rule(field, rule)
      field = field.to_sym
      if rules[field].nil?
        rules[field] = []
      end

      begin
        if rule.respond_to?(:each_pair)
          rule.each_pair do |key, value|
            r = Validation::Rule.const_get(camelize(key))
            rules[field] << r.new(value)
          end
        elsif rule.respond_to?(:each)
          rule.each do |r|
            r = Validation::Rule.const_get(camelize(r))
            rules[field] << r.new
          end
        else
          rule = Validation::Rule.const_get(camelize(rule))
          rules[field] << rule.new
        end
      rescue NameError => e
        raise InvalidRule
      end
    end

    def valid?
      valid = true

      rules.each_pair do |field, rules|
        if ! @obj.respond_to?(field)
          raise InvalidKey
        end

        rules.each do |r|
          if ! r.valid_value?(@obj.send(field))
            valid = false
            errors[field] = {:rule => r.error_key, :params => r.params}
            break
          end
        end
      end

      @valid = valid
    end

    protected

    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/i) { $2.capitalize }.gsub('/', '::')
    end
  end

  class Validator
    include Validation::Rules

    def initialize(obj)
      @obj = obj
    end
  end

  class InvalidKey < RuntimeError
  end

  class InvalidRule < RuntimeError
  end
end
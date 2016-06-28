require 'spec_helper'
require 'validation/rule/regex'

describe Validation::Rule::Regex do
  subject { Validation::Rule::Regex }

  it 'has an error key' do
    expect(subject.new('foo').error_key).to eq(:regex)
  end

  it 'returns its parameters' do
    rule = subject.new(:regex => /\A.+\Z/)
    expect(rule.params).to eq(:regex => /\A.+\Z/)
  end

  context :regex do
    let(:rule) { subject.new(:regex => /\A[0-9]+\Z/) }

    it 'is valid' do
      expect(rule.valid_value?('0123456789')).to eq(true)
    end

    it 'is invalid' do
      expect(rule.valid_value?('a')).to eq(false)
      expect(rule.valid_value?('2b')).to eq(false)
      expect(rule.valid_value?('c3')).to eq(false)
    end
  end
end

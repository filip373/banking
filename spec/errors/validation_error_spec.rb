# frozen_string_literal: true

require_relative '../../app/errors/validation_error'

RSpec.describe ValidationError, type: :error do
  subject { described_class.new }
  it { is_expected.to be_kind_of(StandardError) }
end

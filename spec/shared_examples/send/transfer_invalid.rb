# frozen_string_literal: true

require_relative '../../../app/errors/validation_error'

RSpec.shared_examples 'transfer invalid' do
  it 'raises validation error' do
    expect { subject.call }.to raise_error(ValidationError)
  end
end

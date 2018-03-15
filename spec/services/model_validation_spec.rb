# frozen_string_literal: true

require_relative '../../app/services/model_validation'
require_relative '../../app/errors/validation_error'

RSpec.describe ModelValidation do
  subject { described_class.new model }
  let(:model) { double valid?: valid?, errors: errors }

  describe '#call!' do
    context 'when model is invalid' do
      let(:valid?) { false }

      context 'and contains errors' do
        let(:errors) { 'some errors' }

        it 'raises validation error containing errors' do
          expect { subject.call! }
            .to raise_error(ValidationError, 'some errors')
        end
      end

      context 'and does NOT contain errors' do
        let(:errors) { nil }

        it 'raises validation error without message' do
          expect { subject.call! }.to raise_error(ValidationError, nil)
        end
      end
    end

    context 'when model is valid' do
      let(:valid?) { true }

      context 'and does NOT contain errors' do
        let(:errors) { nil }

        it 'does NOT raise an error' do
          expect { subject.call! }.not_to raise_error
        end
      end

      context 'and contains errors' do
        let(:errors) { 'irrelevant error' }

        it 'does NOT raise an error' do
          expect { subject.call! }.not_to raise_error
        end
      end
    end
  end
end

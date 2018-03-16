# frozen_string_literal: true

require 'shared_examples/subject_valid'
require 'shared_examples/failed_validation'

RSpec.shared_examples 'transfer' do
  describe 'initialization' do
    it 'initializes amount, from and to attributes', :aggregate_failures do
      expect(subject.amount).to eq(amount)
      expect(subject.from).to eq(from)
      expect(subject.to).to eq(to)
    end
  end

  describe 'validation' do
    context 'when transfer attributes are valid' do
      it_behaves_like 'subject valid'
    end

    context 'when from and to account is the same' do
      let(:to) { from }
      it_behaves_like 'failed validation', :same_account
    end

    context 'when amount is less than zero' do
      let(:amount) { -100_00 }
      it_behaves_like 'failed validation', :amount_not_positive
    end

    context 'when amount is zero' do
      let(:amount) { 0 }
      it_behaves_like 'failed validation', :amount_not_positive
    end
  end
end

# frozen_string_literal: true

RSpec.shared_examples 'not sufficient balance' do
  describe '#valid?' do
    it 'returns false' do
      expect(subject.valid?).to be(false)
    end
  end

  describe '#errors' do
    it 'contains :not_sufficient_balance' do
      expect(subject.errors).to contain_exactly(:not_sufficient_balance)
    end
  end
end

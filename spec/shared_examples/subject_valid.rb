# frozen_string_literal: true

RSpec.shared_examples 'subject valid' do
  describe '#valid?' do
    it 'returns true' do
      expect(subject.valid?).to be(true)
    end
  end

  describe '#errors' do
    it 'is empty' do
      expect(subject.errors).to be_empty
    end
  end
end

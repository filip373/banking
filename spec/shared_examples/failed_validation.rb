# frozen_string_literal: true

RSpec.shared_examples 'failed validation' do |error|
  describe '#valid?' do
    it 'returns false' do
      expect(subject.valid?).to be(false)
    end
  end

  describe '#errors' do
    it "contains #{error} error" do
      expect(subject.errors).to contain_exactly(error)
    end
  end
end

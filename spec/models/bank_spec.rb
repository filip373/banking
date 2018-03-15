# frozen_string_literal: true

require_relative '../../app/models/bank'

RSpec.describe Bank, type: :model do
  subject { described_class.new name: name }
  let(:name) { 'test bank' }

  describe 'initialization' do
    it 'initializes name and transfers attributes', :aggregate_failures do
      expect(subject.name).to eq('test bank')
      expect(subject.transfers).to be_empty
    end
  end
end

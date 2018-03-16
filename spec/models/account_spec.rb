# frozen_string_literal: true

require_relative '../../app/models/account'
require_relative '../../app/models/bank'

RSpec.describe Account, type: :model do
  subject { described_class.new holder: holder, balance: balance, bank: bank }
  let(:holder) { 'joe' }
  let(:balance) { 4_000_00 }
  let(:bank) { Bank.new name: 'test bank' }

  describe 'initialization' do
    it 'initializes holder, balance and bank attributes', :aggregate_failures do
      expect(subject.holder).to eq('joe')
      expect(subject.balance).to eq(4_000_00)
      expect(subject.bank).to eq(bank)
    end
  end
end

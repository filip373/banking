# frozen_string_literal: true

require 'shared_examples/transfer'
require 'shared_examples/not_sufficient_balance'
require_relative '../../app/models/inter_transfer'
require_relative '../../app/models/transfer'
require_relative '../../app/models/account'
require_relative '../../app/models/bank'

RSpec.describe InterTransfer, type: :model do
  subject { described_class.new transfer }
  let(:transfer) { Transfer.new from: from, to: to, amount: amount }

  let(:amount) { 150_00 }
  let(:from) do
    Account.new holder: 'joe', bank: bank_from, balance: balance_from
  end
  let(:to) { Account.new holder: 'eve', bank: bank_to, balance: 5_000_00 }
  let(:balance_from) { 5_000_00 }

  let(:bank_from) { Bank.new name: 'test bank a' }
  let(:bank_to) { Bank.new name: 'test bank b' }

  it_behaves_like 'transfer'

  describe 'validation' do
    context 'when bank is the same for both accounts' do
      let(:bank_to) { bank_from }

      describe '#valid?' do
        it 'returns false' do
          expect(subject.valid?).to be(false)
        end
      end

      describe '#errors' do
        it 'contains :same_bank' do
          expect(subject.errors).to contain_exactly(:same_bank)
        end
      end
    end

    context 'when balance is the same as transfer amount + commission' do
      let(:balance_from) { 155_00 }
      it_behaves_like 'subject valid'
    end

    context 'when balance is lower than transfer amount + commission' do
      let(:balance_from) { 150_00 }
      it_behaves_like 'not sufficient balance'
    end
  end
end

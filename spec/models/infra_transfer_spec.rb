# frozen_string_literal: true

require 'shared_examples/transfer'
require_relative '../../app/models/infra_transfer'
require_relative '../../app/models/transfer'
require_relative '../../app/models/account'
require_relative '../../app/models/bank'

RSpec.describe InfraTransfer, type: :model do
  subject { described_class.new transfer }
  let(:transfer) { Transfer.new from: from, to: to, amount: amount }

  let(:amount) { 150_00 }
  let(:from) do
    Account.new holder: 'joe', bank: bank_from, balance: balance_from
  end
  let(:to) { Account.new holder: 'eve', bank: bank_to, balance: 5_000_00 }
  let(:balance_from) { 5_000_00 }

  let(:bank_from) { Bank.new name: 'test bank a' }
  let(:bank_to) { bank_from }

  it_behaves_like 'transfer'

  describe 'validation' do
    context 'when bank is NOT the same for both accounts' do
      let(:bank_to) { Bank.new name: 'other bank' }
      it_behaves_like 'failed validation', :not_same_bank
    end

    context 'when balance is the same as transfer amount' do
      let(:balance_from) { 150_00 }
      it_behaves_like 'subject valid'
    end

    context 'when balance is lower than transfer amount' do
      let(:balance_from) { 10_00 }
      it_behaves_like 'failed validation', :not_sufficient_balance
    end
  end
end

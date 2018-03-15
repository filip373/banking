# frozen_string_literal: true

require_relative '../../app/models/transfer'
require_relative '../../app/models/bank'
require_relative '../../app/models/account'
require_relative '../../app/services/log_transfer'

RSpec.describe LogTransfer do
  describe '#call' do
    let(:first_transfer) { Transfer.new from: joe, to: eve, amount: 100_00 }
    let(:second_transfer) { Transfer.new from: eve, to: joe, amount: 150_00 }
    let(:joe) { Account.new holder: 'joe', balance: 1_500_00, bank: bank_joe }
    let(:eve) { Account.new holder: 'eve', balance: 1_000_00, bank: bank_eve }
    let(:bank_joe) { Bank.new name: 'first' }
    let(:valid_history) do
      [
        {
          transfer: first_transfer,
          status: :a
        },
        {
          transfer: second_transfer,
          status: :b
        }
      ]
    end

    before do
      described_class.new(transfer: first_transfer, status: :a).call
      described_class.new(transfer: second_transfer, status: :b).call
    end

    context 'with different banks' do
      let(:bank_eve) { Bank.new name: 'second' }

      it "adds ordered transfers to both banks' history", :aggregate_failures do
        expect(bank_eve.transfers).to eq(valid_history)
        expect(bank_joe.transfers).to eq(valid_history)
      end
    end

    context 'with the same bank' do
      let(:bank_eve) { bank_joe }

      it "adds ordered transfers to bank's history", :aggregate_failure do
        expect(bank_eve.transfers).to eq(valid_history)
        expect(bank_joe.transfers).to eq(valid_history)
      end
    end
  end
end

# frozen_string_literal: true

require 'shared_examples/send/transfer_invalid'
require_relative '../../../app/models/transfer'
require_relative '../../../app/models/bank'
require_relative '../../../app/models/account'
require_relative '../../../app/services/send/infra_transfer'

RSpec.describe Send::InfraTransfer, type: :service do
  subject { described_class.new transfer }
  let(:transfer) { Transfer.new from: joe, to: eve, amount: 1_000_00 }
  let(:joe) { Account.new holder: 'joe', balance: 1_500_00, bank: joe_bank }
  let(:eve) { Account.new holder: 'eve', balance: 1_000_00, bank: eve_bank }
  let(:joe_bank) { Bank.new name: 'first' }
  let(:eve_bank) { joe_bank }

  describe '#call' do
    context 'when transfer is NOT valid' do
      let(:eve_bank) { Bank.new name: 'second' }
      include_examples 'transfer invalid'
    end

    context 'when transfer is valid' do
      it 'takes amount from sender balance' do
        subject.call
        expect(joe.balance).to eq(500_00)
      end

      it 'gives amount to receiver balance' do
        subject.call
        expect(eve.balance).to eq(2_000_00)
      end

      describe 'logging' do
        before { allow(LogTransfer).to receive(:new).and_return(log_transfer) }
        let(:log_transfer) { double call: nil }

        it 'calls log service with :success status', :aggregate_failures do
          expect(LogTransfer)
            .to receive(:new)
            .with(transfer: instance_of(InfraTransfer), status: :success)
          expect(log_transfer).to receive(:call).with(no_args)
          subject.call
        end
      end
    end
  end
end

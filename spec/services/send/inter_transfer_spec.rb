# frozen_string_literal: true

require 'shared_examples/send/transfer_invalid'
require_relative '../../../app/models/transfer'
require_relative '../../../app/models/bank'
require_relative '../../../app/models/account'
require_relative '../../../app/services/send/inter_transfer'

RSpec.describe Send::InterTransfer, type: :service do
  subject { described_class.new transfer, fail_chance: fail_chance }
  let(:transfer) { Transfer.new from: joe, to: eve, amount: 1_000_00 }
  let(:joe) { Account.new holder: 'joe', balance: 1_500_00, bank: joe_bank }
  let(:eve) { Account.new holder: 'eve', balance: 1_000_00, bank: eve_bank }
  let(:joe_bank) { Bank.new name: 'first' }
  let(:eve_bank) { Bank.new name: 'second' }
  let(:fail_chance) { 30 }

  describe '#call' do
    context 'when transfer is NOT valid' do
      let(:eve_bank) { joe_bank }
      include_examples 'transfer invalid'
    end

    context 'when fail chance is 0' do
      let(:fail_chance) { 0 }

      it 'does NOT raise an error' do
        expect { subject.call }.not_to raise_error
      end
    end

    context 'when fail change is 100' do
      let(:fail_chance) { 100 }

      it 'raises a TransferFailure error' do
        expect { subject.call }.to raise_error(TransferFailure)
      end
    end

    context 'when transfer is valid' do
      context 'and does NOT raise a TransferFailure error' do
        let(:fail_chance) { 0 }

        it 'takes amount plus commission from sender balance' do
          subject.call
          expect(joe.balance).to eq(495_00)
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
              .with(transfer: instance_of(InterTransfer), status: :success)
            expect(log_transfer).to receive(:call).with(no_args)
            subject.call
          end
        end
      end

      context 'and raises an TransferFailure error' do
        let(:fail_chance) { 100 }

        it 'raises TransferFailure error' do
          expect { subject.call }
            .to raise_error(TransferFailure)
        end

        it 'does NOT take any money from sender balance' do
          subject.call rescue nil
          expect(joe.balance).to eq(1_500_00)
        end

        it 'does NOT give any amoun to receiver balance' do
          subject.call rescue nil
          expect(eve.balance).to eq(1_000_00)
        end

        describe 'logging' do
          before { allow(LogTransfer).to receive(:new).and_return(log_transfer) }
          let(:log_transfer) { double call: nil }

          it 'calls log service with :failure status', :aggregate_failures do
            expect(LogTransfer)
              .to receive(:new)
              .with(transfer: instance_of(InterTransfer), status: :failure)
            expect(log_transfer).to receive(:call).with(no_args)
            subject.call rescue nil
          end
        end
      end
    end
  end
end

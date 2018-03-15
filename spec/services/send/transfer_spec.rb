# frozen_string_literal: true

require 'shared_examples/send/transfer_invalid'
require_relative '../../../app/models/transfer'
require_relative '../../../app/models/bank'
require_relative '../../../app/models/account'
require_relative '../../../app/services/send/transfer'

RSpec.describe Send::Transfer, type: :service do
  subject { described_class.new transfer }
  let(:transfer) { Transfer.new from: eve, to: joe, amount: amount }
  let(:amount) { 100_00 }
  let(:joe) { Account.new holder: 'joe', balance: 1_500_00, bank: bank }
  let(:eve) { Account.new holder: 'eve', balance: 1_000_00, bank: bank }
  let(:bank) { Bank.new name: 'first' }

  describe '#call' do
    context 'when transfer is NOT valid' do
      let(:amount) { -100_00 }
      include_examples 'transfer invalid'
    end

    context 'when transfer is valid' do
      it 'raises not implement error' do
        expect { subject.call }.to raise_error('implement in child classes')
      end
    end
  end
end

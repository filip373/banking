# frozen_string_literal: true

require_relative '../../app/services/transfer_agent'

RSpec.describe TransferAgent, type: :service do
  subject { described_class.new transfer, max_retries: max_retries }
  let(:transfer) { double }
  let(:max_retries) { 3 }

  describe '#call' do
    shared_examples 'does NOT raise an error' do
      it 'does NOT raise an error' do
        expect { subject.call }.not_to raise_error
      end
    end

    context 'when transfer succeeds at the first time' do
      before { allow(transfer).to receive(:call).once.and_return(true) }

      include_examples 'does NOT raise an error'

      it 'tries to process the transfer just once' do
        expect(transfer).to receive(:call).once.with(no_args)
        subject.call
      end
    end

    context 'when transfer succeeds at the third time' do
      before do
        response_values = [false, false, true]
        allow(transfer).to receive(:call).thrice.with(no_args) do
          response_values.shift || raise(TransferFailure)
        end
      end

      context 'and retries count is 1 (less than failures count)' do
        let(:max_retries) { 1 }
        let(:call_and_rescue) do
          begin
            subject.call
          rescue TransferFailure
            nil
          end
        end

        it 'raises TransferFailure error' do
          expect { subject.call }.to raise_error(TransferFailure)
        end

        it 'tries to process transfer twice' do
          expect(transfer).to receive(:call).twice.with(no_args)
          call_and_rescue
        end
      end

      context 'and retries count is 2 (equal to failures count)' do
        let(:max_retries) { 2 }

        include_examples 'does NOT raise an error'

        it 'tries to process the transfer thrice' do
          expect(transfer).to receive(:call).thrice.with(no_args)
          subject.call
        end
      end

      context 'and retries count is 3 (more than failures count)' do
        let(:max_retries) { 3 }

        include_examples 'does NOT raise an error'

        it 'tries to process the transfer thrice' do
          expect(transfer).to receive(:call).thrice.with(no_args)
          subject.call
        end
      end
    end
  end
end

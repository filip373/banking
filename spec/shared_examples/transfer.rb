# frozen_string_literal: true

require 'shared_examples/subject_valid'

RSpec.shared_examples 'transfer' do
  describe 'initialization' do
    it 'initializes amount, from and to attributes', :aggregate_failures do
      expect(subject.amount).to eq(amount)
      expect(subject.from).to eq(from)
      expect(subject.to).to eq(to)
    end
  end

  describe 'validation' do
    context 'when transfer attributes are valid' do
      it_behaves_like 'subject valid'
    end

    context 'when from and to account is the same' do
      let(:to) { from }

      describe '#valid?' do
        it 'returns false' do
          expect(subject.valid?).to be(false)
        end
      end

      describe '#errors' do
        it 'contains :same_account' do
          expect(subject.errors).to contain_exactly(:same_account)
        end
      end
    end

    shared_examples 'non positive amount' do
      describe '#valid?' do
        it 'returns false' do
          expect(subject.valid?).to be(false)
        end
      end

      describe '#errors' do
        it 'contains :non_positive_amount' do
          expect(subject.errors).to contain_exactly(:amount_not_positive)
        end
      end
    end

    context 'when amount is less than zero' do
      let(:amount) { -100_00 }
      it_behaves_like 'non positive amount'
    end

    context 'when amount is zero' do
      let(:amount) { 0 }
      it_behaves_like 'non positive amount'
    end
  end
end

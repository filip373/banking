# frozen_string_literal: true

require 'shared_examples/transfer'
require_relative '../../app/models/transfer'
require_relative '../../app/models/account'
require_relative '../../app/models/bank'

RSpec.describe Transfer, type: :model do
  subject { described_class.new amount: amount, from: from, to: to }
  let(:amount) { 150_00 }
  let(:from) { Account.new holder: 'joe', bank: bank, balance: 10_000_00 }
  let(:to) { Account.new holder: 'eve', bank: bank, balance: 5_000_00 }
  let(:bank) { Bank.new name: 'test bank' }

  it_behaves_like 'transfer'
end

# frozen_string_literal: true

require_relative '../app/models/account'
require_relative '../app/models/bank'
require_relative '../app/models/transfer'
require_relative '../app/services/transfer_agent'
require_relative '../app/services/send/infra_transfer'
require_relative '../app/services/send/inter_transfer'
require_relative '../app/services/print/history'
require_relative '../app/services/print/account'

# Initialization

bank_a = Bank.new name: 'A'
bank_b = Bank.new name: 'B'

jim_account = Account.new holder: 'Jim', balance: 100_000_00, bank: bank_a
emma_account = Account.new holder: 'Emma', balance: 5_000_00, bank: bank_b

# Print before

puts '-- Before transfers --', "\n"

puts Print::History.new(bank_a).call
puts Print::History.new(bank_b).call, "\n"

puts Print::Account.new(jim_account).call
puts Print::Account.new(emma_account).call, "\n"

# Make transfer

20.times do
  TransferAgent.new(
    Send::InterTransfer.new(
      Transfer.new(from: jim_account, to: emma_account, amount: 1_000_00)
    )
  ).call
end

# Print after

puts '-- After transfers --', "\n"

puts Print::Account.new(jim_account).call
puts Print::Account.new(emma_account).call, "\n"

puts Print::History.new(bank_a).call
puts Print::History.new(bank_b).call

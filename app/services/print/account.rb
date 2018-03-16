# frozen_string_literal: true

require_relative './euro'

module Print
  class Account
    def initialize(account)
      @account = account
    end

    def call
      "#{@account.holder} has #{balance} in bank #{@account.bank.name}"
    end

    private

    def balance
      Print::Euro.new(@account.balance).call
    end
  end
end

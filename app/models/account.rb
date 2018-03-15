# frozen_string_literal: true

class Account
  attr_accessor :holder, :balance, :bank

  def initialize(holder:, balance:, bank:)
    @holder = holder
    @balance = balance
    @bank = bank
  end
end

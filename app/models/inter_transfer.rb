# frozen_string_literal: true

require_relative './transfer'

class InterTransfer < Transfer
  def initialize(transfer)
    super from: transfer.from, to: transfer.to, amount: transfer.amount
  end

  def commission
    COMMISSION
  end

  def errors
    [
      same_bank,
      not_sufficient_balance,
      above_limit
    ].compact.concat super
  end

  private

  COMMISSION = 5_00
  LIMIT = 1_000_00

  def same_bank
    return if @from == @to || @from.bank != @to.bank
    :same_bank
  end

  def not_sufficient_balance
    return if @from.balance >= (@amount + COMMISSION)
    :not_sufficient_balance
  end

  def above_limit
    return if @amount <= LIMIT
    :above_limit
  end
end

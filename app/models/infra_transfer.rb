# frozen_string_literal: true

require_relative './transfer'

class InfraTransfer < Transfer
  def initialize(transfer)
    super from: transfer.from, to: transfer.to, amount: transfer.amount
  end

  def valid?
    super && not_sufficient_balance.nil? && not_same_bank.nil?
  end

  def errors
    [
      not_same_bank,
      not_sufficient_balance
    ].compact.concat super
  end

  private

  def not_same_bank
    return if @from.bank == @to.bank
    :not_same_bank
  end

  def not_sufficient_balance
    return if @from.balance >= @amount
    :not_sufficient_balance
  end
end

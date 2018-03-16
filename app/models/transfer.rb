# frozen_string_literal: true

class Transfer
  attr_accessor :amount, :from, :to

  # rubocop:disable Naming/UncommunicativeMethodParamName
  def initialize(amount:, from:, to:)
    # rubocop:enable Naming/UncommunicativeMethodParamName
    @amount = amount
    @from = from
    @to = to
  end

  def valid?
    errors.none?
  end

  def errors
    [
      same_account,
      amount_not_positive
    ].compact
  end

  private

  def same_account
    return if @from != @to
    :same_account
  end

  def amount_not_positive
    return if @amount.positive?
    :amount_not_positive
  end
end

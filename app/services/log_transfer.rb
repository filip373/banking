# frozen_string_literal: true

class LogTransfer
  def initialize(transfer:, status:)
    @transfer = transfer
    @status = status
  end

  def call
    @transfer.from.bank.transfers.push log_hash
    @transfer.to.bank.transfers.push log_hash unless same_bank?
  end

  private

  def same_bank?
    @transfer.from.bank == @transfer.to.bank
  end

  def log_hash
    {
      transfer: @transfer,
      status: @status
    }
  end
end

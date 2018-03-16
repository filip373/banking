# frozen_string_literal: true

require_relative '../errors/transfer_failure'

class TransferAgent
  def initialize(transfer, max_retries: 10)
    @transfer = transfer
    @max_retries = max_retries
  end

  def call
    raise TransferFailure unless try_processing
  end

  private

  def try_processing
    tries.times { return true if process_transfer }
    false
  end

  def tries
    1 + @max_retries
  end

  def process_transfer
    @transfer.call
    true
  rescue TransferFailure
    false
  end
end

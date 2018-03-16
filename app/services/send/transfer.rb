# frozen_string_literal: true

require_relative '../log_transfer'
require_relative '../model_validation'
require_relative '../../errors/transfer_failure'

module Send
  class Transfer
    def initialize(transfer)
      @transfer = transfer
    end

    def call
      validate!
      process
      log :success
    rescue TransferFailure
      log :failure
      raise
    end

    private

    def process
      raise 'implement in child classes'
    end

    def validate!
      ModelValidation.new(@transfer).call!
    end

    def log(status)
      LogTransfer.new(transfer: @transfer, status: status).call
    end
  end
end

# frozen_string_literal: true

require_relative './transfer'
require_relative '../../models/inter_transfer'
require_relative '../../errors/transfer_failure'

module Send
  class InterTransfer < Transfer
    def initialize(transfer, fail_chance: 30)
      super ::InterTransfer.new(transfer)
      @fail_chance = fail_chance
    end

    protected

    def process
      raise TransferFailure, :transfer_failed if failed?
      @transfer.from.balance -= (@transfer.amount + @transfer.commission)
      @transfer.to.balance += @transfer.amount
    end

    private

    def failed?
      random_percent < @fail_chance
    end

    def random_percent
      Random.rand 100
    end
  end
end

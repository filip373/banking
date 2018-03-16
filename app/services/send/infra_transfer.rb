# frozen_string_literal: true

require_relative './transfer'
require_relative '../../models/infra_transfer'

module Send
  class InfraTransfer < Transfer
    def initialize(transfer)
      super ::InfraTransfer.new(transfer)
    end

    protected

    def process
      @transfer.from.balance -= @transfer.amount
      @transfer.to.balance += @transfer.amount
    end
  end
end

# frozen_string_literal: true

require_relative './euro'

module Print
  class Transfer
    def initialize(transfer)
      @transfer = transfer
    end

    def call
      "#{@transfer.from.holder} -> #{@transfer.to.holder}: #{printed_amount}"
    end

    private

    def printed_amount
      Print::Euro.new(@transfer.amount).call
    end
  end
end

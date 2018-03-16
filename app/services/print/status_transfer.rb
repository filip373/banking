# frozen_string_literal: true

module Print
  class StatusTransfer
    def initialize(print_transfer:, status:)
      @print_transfer = print_transfer
      @status = status
    end

    def call
      "#{@print_transfer.call} - #{@status}"
    end
  end
end

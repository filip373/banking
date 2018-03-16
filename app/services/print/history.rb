# frozen_string_literal: true

require_relative './transfer'
require_relative './status_transfer'

module Print
  class History
    def initialize(bank)
      @bank = bank
    end

    def call
      "#{title}#{history}"
    end

    private

    def title
      "Bank #{@bank.name} history:"
    end

    def history
      @bank.transfers.any? ? transfers.prepend("\n") : empty_message
    end

    def transfers
      printed_transfers.join("\n")
    end

    def empty_message
      ' ** no transfers **'
    end

    def printed_transfers
      @bank.transfers.map do |hash|
        Print::StatusTransfer.new(
          print_transfer: Print::Transfer.new(hash[:transfer]),
          status: hash[:status]
        ).call
      end
    end
  end
end

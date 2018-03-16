# frozen_string_literal: true

module Print
  class Euro
    def initialize(amount)
      @amount = amount
    end

    def call
      "#{@amount} EUR"
    end
  end
end

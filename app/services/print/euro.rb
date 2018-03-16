# frozen_string_literal: true

module Print
  class Euro
    def initialize(amount)
      @amount = amount
    end

    def call
      "#{print_amount} EUR"
    end

    private

    def print_amount
      printed = @amount.to_s
      dots_indexes = (-printed.length...-3).select { |n| (n % 3).zero? }
      dots_indexes.each { |i| printed.insert i, '.' }
      printed.insert(-3, ',')
      printed
    end
  end
end

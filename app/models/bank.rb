# frozen_string_literal: true

class Bank
  attr_accessor :name, :transfers

  def initialize(name:)
    @name = name
    @transfers = []
  end
end

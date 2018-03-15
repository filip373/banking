# frozen_string_literal: true

require_relative '../errors/validation_error'

class ModelValidation
  def initialize(model)
    @model = model
  end

  def call!
    raise ValidationError, @model.errors unless @model.valid?
  end
end

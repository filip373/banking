# Code Test: Banking

## Running
Run the script with ```ruby bin/show_me_the_money.rb```

## Testing
Run rspec with ```bundle exec rspec```

## Solution approach:
* models contains only related attributes, associations and validation logic
* the whole business logic is divided in separate services for better separation
  of concerns and single responsibility
* `InfraTransfer` and `InterTransfer` models inherit from `Transfer` class and
  reuses the common validation while adding some child-specific validations
* `Send::Transfer` class takes care of common transfer sending logic like
  validating the transfer, logging it to the bank history and handling failures
* `Send::InterTransfer` and `Send::InfraTransfer` services inherit from `Send::Transfer`
  'abstract' class and use template pattern to implement only `process` logic
  which changes depending on a child class
* transfer agent includes limit number of possible retries when the transfer
  fails and raises an error after failing to process a transfer within the max
  retries limit
* banks are logging every transfer with their status, failed or success using
  separate service `LogTransfer`
* printing included in own services to separate logic related to formatting
  the end-user output
* `Print::StatusTransfer` is a decorator for `Print::Transfer` service and adds
  printing the status of the transfer

## Possible improvements:
* add specs for printing services
* implement class representing money and taking care of the validations
* implement class representing logged transfer, containing transfer and its
  status (success or failed), ensuring valid status
* remove `#valid?` method from models so `errors` becomes the only
  source-of-truth for the validation
* use gem like FactoryBot for instantiating models in specs
* use dry-rb to handle model types

## If transfers were not instantaneous:
* make transfers possible to run in parallel (asynchronous)
* taking transfer orders in main thread and using background worker for actually executing them (sidekiq?)
* use transaction for every transfer:
  * only one transaction can happen at the given moment in time
  * either whole transaction passes and both balanced are changed or it does not
    pass and no balance is changed

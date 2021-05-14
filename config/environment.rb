# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Whatup::Application.initialize!

custom_logger = Logger.new(STDOUT)
Rails.logger.extend(ActiveSupport::Logger.broadcast(custom_logger))
custom_logger.debug('testing...................')

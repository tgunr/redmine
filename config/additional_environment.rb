# Copy this file to additional_environment.rb and add any statements
# that need to be passed to the Rails::Initializer.  `config` is
# available in this context.
#
# Example:
#
#   config.log_level = :debug
#   ...
#
config.logger = Logger.new('/usr/share/redmine/log/production.log', 2, 1000000)
config.logger.level = Logger::INFO

#config.logger = Logger.new('/usr/share/redmine/log/production.log', 2, 1000000)
#config.logger.level = Logger::DEBUG

# Initialize the Rails application.
# SnowSchoolers::Application.initialize!

# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# load default titles
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")

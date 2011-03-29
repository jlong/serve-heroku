#\ -p 4000

gem 'activesupport'
gem 'serve'

require 'serve'
require 'serve/rack'

require 'sass/plugin/rack'
require 'compass'

# The project root directory
root = ::File.dirname(__FILE__)

# Compass
Compass.add_project_configuration(root + '/compass.config')
Compass.configure_sass_plugin!

# Rack Middleware
use Rack::ShowStatus      # Nice looking 404s and other messages
use Rack::ShowExceptions  # Nice looking errors
unless ENV['RACK_ENV'] == "production"
  use Sass::Plugin::Rack    # Compile Sass on the fly
end

run Rack::Cascade.new([
  Serve::RackAdapter.new(root + '/views'),
  Rack::Directory.new(root + '/public')
])

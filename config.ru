#\ -p 4000

gem 'activesupport'
gem 'serve'

require 'serve'
require 'serve/rack'

# The project root directory
root = ::File.dirname(__FILE__)

# Common Rack Middleware
use Rack::ShowStatus      # Nice looking 404s and other messages
use Rack::ShowExceptions  # Nice looking errors

if ENV['RACK_ENV'] == "production"
  # Use Rack::Static with Heroku
  use Rack::Static, :urls => ["/images", "/javascripts", "/stylesheets"], :root => "public"
  run Serve::RackAdapter.new(root + '/views')
else
  # Compile Sass on the fly
  require 'sass/plugin/rack'
  require 'compass'
  Compass.add_project_configuration(root + '/compass.config')
  Compass.configure_sass_plugin!
  use Sass::Plugin::Rack
  
  # Use Rack::Cascade and Rack::Directory to handle
  # files in public directory gracefully
  run Rack::Cascade.new([
    Serve::RackAdapter.new(root + '/views'),
    Rack::Directory.new(root + '/public')
  ])
end

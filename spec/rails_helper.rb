ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rspec/rails'

Dir[__dir__ + '/support/**/*'].each { |f| require f if File.file?(f) }

begin
   require 'rubygems'
   require_gem 'builder', '~> 1.2'
rescue LoadError
   require 'builder'
end

require 'quickbooks/connection'
require 'quickbooks/models/models'

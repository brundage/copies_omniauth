$:.unshift(File.dirname(__FILE__) + '/../lib')
rspec_dir = File.dirname(__FILE__)

ENV["RAILS_ENV"] ||= "test"

require 'rails/all'
require 'copies_omniauth'

ActiveRecord::Base.configurations = YAML::load(File.open(File.join(rspec_dir, "/db", "database.yml")))
ActiveRecord::Base.establish_connection(ENV["DB"] || "test")
ActiveRecord::Base.logger = Logger.new(File.join(rspec_dir, "debug.log"))
ActiveRecord::Migration.verbose = false
load(File.join(rspec_dir, "db", "schema.rb"))

ActiveSupport.run_load_hooks(:active_record)

OMNIAUTHS = YAML::load(File.open(File.join(rspec_dir, "omniauths.yml")))

Dir[File.join(rspec_dir,"models","*.rb")].each { |f| require f }

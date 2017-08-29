# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'simple_bdd'
require 'shoulda/matchers'
require 'pundit/rspec'
include ActionDispatch::TestProcess

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include SimpleBdd, type: :feature
  # config.include Devise::TestHelpers, :type => :controller  

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  Capybara.javascript_driver = :webkit

  Capybara::Webkit.configure do |config|
    config.allow_url("https://maps.googleapis.com/maps-api-v3/api/js/28/2/common.js")
    config.allow_url("maps.googleapis.com")
    config.allow_url("https://maps.googleapis.com/maps-api-v3/api/js/28/2/util.js")
    config.allow_url("https://maps.googleapis.com/maps-api-v3/api/js/28/2/stats.js")
    config.allow_url("csi.gstatic.com")
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do 
    DatabaseCleaner.clean
  end

  config.include Warden::Test::Helpers
  config.before :suite do 
    Warden.test_mode!
  end 

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  
  config.filter_rails_from_backtrace!

end
    
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end  
  
OmniAuth.config.test_mode = true
     OmniAuth.config.mock_auth[:stripe_connect] =
     OmniAuth::AuthHash.new({
       provider: "stripe",
       uid: "123545",
       credentials: {
         token: "13123123123"
       },
       info: {
         stripe_publishable_key: "123123123123"
  } 
})
   

  



require File.expand_path('../../config/environment', __FILE__)
require 'minitest/reporters'
require 'rails/test_help'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def log_in_as(user, password: 'chicken')
    post user_session_path, params: { user: {email: user.email, password: password}}
  end

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def full_name_apartment(apartment)
    "#{apartment.floor}º#{apartment.letter.capitalize}"
  end

end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

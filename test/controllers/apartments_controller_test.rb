require 'test_helper'

class ApartmentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @apartment = apartments(:primero)
  end

  test 'should get new' do
    get new_apartment_path
    assert_response :success
  end

  test 'should get index' do
    get apartments_path
    assert_response :success
  end

  #TODO finish apartments tests after having user creation

end

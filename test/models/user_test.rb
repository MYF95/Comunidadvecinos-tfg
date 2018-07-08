require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user)
  end

  test 'Users - destroy user should destroy association with apartments' do
    assert_difference 'UserApartment.count', -1 do
      assert_no_difference 'Apartment.count' do
        @user.destroy
      end
    end
  end

  test 'Users - destroy user should destroy owner association with apartments' do
    assert_difference 'ApartmentOwner.count', -1 do
      assert_no_difference 'Apartment.count' do
        @user.destroy
      end
    end
  end

end

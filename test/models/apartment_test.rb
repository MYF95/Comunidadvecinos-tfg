require 'test_helper'

class ApartmentTest < ActiveSupport::TestCase
  def setup
    @apartment = apartments(:apartment1)
    @movement = movements(:movement1)
    @apartment_movement = apartment_movements(:apartment_movement1)
    @user_apartment = user_apartments(:user_apartment1)
  end

  test 'Apartment - should be valid' do
    assert @apartment.valid?
  end

  test 'Apartment - floor should be present' do
    @apartment.floor = ""
    assert_not @apartment.valid?
  end

  test 'Apartment - letter should be present' do
    @apartment.letter = ""
    assert_not @apartment.valid?
  end

  test 'Apartment - letter should be of length 1' do
    @apartment.letter = ""
    assert_not @apartment.valid?
    @apartment.letter = "A"
    assert @apartment.valid?
    @apartment.letter = "AA"
    assert_not @apartment.valid?
  end

  test 'Apartment - floor should not be negative' do
    @apartment.floor = -1
    assert_not @apartment.valid?
  end

  test 'Apartment - fee should be present' do
    @apartment.fee = "";
    assert_not @apartment.valid?
  end

  test 'Apartment - fee should not be negative' do
    @apartment.fee = -1
    assert_not @apartment.valid?
  end

  test 'Apartment - apartment_contribution should be between 0 and 1' do
    @apartment.apartment_contribution = 0
    assert @apartment.valid?
    @apartment.apartment_contribution = 1
    assert @apartment.valid?
    @apartment.apartment_contribution = 1.1
    assert_not @apartment.valid?
    @apartment.apartment_contribution = -0.5
    assert_not @apartment.valid?
  end

  test 'Apartment - destroy apartment should destroy association with movements' do
    assert_difference 'ApartmentMovement.count', -2 do
      assert_no_difference 'Movement.count' do
        @apartment.destroy
      end
    end
  end

  test 'Apartment - destroy apartment should destroy association with users' do
    assert_difference 'UserApartment.count', -2 do
      assert_no_difference 'User.count' do
        @apartment.destroy
      end
    end
  end

  test 'Apartment - destroy apartment should destroy association with owner' do
    assert_difference 'ApartmentOwner.count', -1 do
      assert_no_difference 'User.count' do
        @apartment.destroy
      end
    end
  end

  test 'Apartment - destroy apartment should destroy association with pending payments' do
    assert_difference 'ApartmentOwner.count', -1 do
      assert_no_difference 'User.count' do
        @apartment.destroy
      end
    end
  end
end

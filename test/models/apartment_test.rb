require 'test_helper'

class ApartmentTest < ActiveSupport::TestCase
  def setup
    @apartment = apartments(:apartment1)
    @movement = movements(:movement1)
    @apartment_movement = apartment_movements(:apartment_movement1)
    @user_apartment = user_apartments(:user_apartment1)
  end

  test 'Apartment Model 001 - should be valid' do
    assert @apartment.valid?
  end

  test 'Apartment Model 002 - floor should be present' do
    @apartment.floor = ""
    assert_not @apartment.valid?
  end

  test 'Apartment Model 003 - letter should be present' do
    @apartment.letter = ""
    assert_not @apartment.valid?
  end

  test 'Apartment Model 004 - letter should be of length 1' do
    @apartment.letter = ""
    assert_not @apartment.valid?
    @apartment.letter = "A"
    assert @apartment.valid?
    @apartment.letter = "AA"
    assert_not @apartment.valid?
  end

  test 'Apartment Model 005 - floor should not be negative' do
    @apartment.floor = -1
    assert_not @apartment.valid?
  end

  test 'Apartment Model 006 - fee should be present' do
    @apartment.fee = ""
    assert_not @apartment.valid?
  end

  test 'Apartment Model 007 - fee should not be negative' do
    @apartment.fee = -1
    assert_not @apartment.valid?
  end

  test 'Apartment Model 008 - apartment_contribution should be between 0 and 1' do
    @apartment.apartment_contribution = 0
    assert @apartment.valid?
    @apartment.apartment_contribution = 1
    assert @apartment.valid?
    @apartment.apartment_contribution = 1.1
    assert_not @apartment.valid?
    @apartment.apartment_contribution = -0.5
    assert_not @apartment.valid?
  end

  test 'Apartment Model 009 - destroy apartment should destroy association with movements' do
    assert_difference 'ApartmentMovement.count', -2 do
      assert_no_difference 'Movement.count' do
        @apartment.destroy
      end
    end
  end

  test 'Apartment Model 010 - destroy apartment should destroy association with users' do
    assert_difference 'UserApartment.count', -1 do
      assert_no_difference 'User.count' do
        @apartment.destroy
      end
    end
  end

  test 'Apartment Model 011 - destroy apartment should destroy association with owner' do
    assert_difference 'ApartmentOwner.count', -1 do
      assert_no_difference 'User.count' do
        @apartment.destroy
      end
    end
  end

  test 'Apartment Model 012 - destroy apartment should destroy association with pending payments' do
    assert_difference 'ApartmentPendingPayment.count', -1 do
      assert_no_difference 'PendingPayment.count' do
        @apartment.destroy
      end
    end
  end
end

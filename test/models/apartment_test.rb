require 'test_helper'

class ApartmentTest < ActiveSupport::TestCase
  def setup
    @apartment = apartments(:primero)
  end

  test 'Apartment - should be valid' do
    assert @apartment.valid?
  end

  test 'Apartment - floor should be present' do
    @apartment.floor = "";
    assert_not @apartment.valid?
  end

  test 'Apartment - letter should be present' do
    @apartment.letter = "";
    assert_not @apartment.valid?
  end

  test 'Apartment - letter should be of length 1' do

  end

  test 'Apartment - letter when saved should always be capitalized' do

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

  end

  test 'Apartment - destroy apartment should destroy association with movements' do

  end

  test 'Apartment - destroy apartment should destroy association with users' do

  end

  test 'Apartment - destroy apartment should destroy association with owner' do

  end

  test 'Apartment - destroy apartment should destroy association with pending payments' do

  end
end

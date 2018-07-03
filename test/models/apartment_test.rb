require 'test_helper'

class ApartmentTest < ActiveSupport::TestCase
  def setup
    @apartment = apartments(:primero)
  end

  test 'apartment should be valid' do
    assert @apartment.valid?
  end

  test 'floor should be present' do
    @apartment.floor = "";
    assert_not @apartment.valid?
  end

  test 'letter should be present' do
    @apartment.letter = "";
    assert_not @apartment.valid?
  end

  test 'floor should not be negative' do
    @apartment.floor = -1
    assert_not @apartment.valid?
  end

  test 'fee should be present' do
    @apartment.fee = "";
    assert_not @apartment.valid?
  end

  test 'fee should not be negative' do
    @apartment.fee = -1
    assert_not @apartment.valid?
  end
end

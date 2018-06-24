require 'test_helper'

class MovementTest < ActiveSupport::TestCase

  def setup
    @movement = movements(:ingreso1)
  end

  test '@movement should be valid' do
    assert @movement.valid?
  end

  test 'concept should be present' do
    @movement.concept = "";
    assert_not @movement.valid?
  end

  test 'date should be present' do
    @movement.date = "";
    assert_not @movement.valid?
  end

  test 'amount should be present' do
    @movement.amount = "";
    assert_not @movement.valid?
  end

  test 'amount should not be negative' do
    @movement.amount = -1
    assert_not @movement.valid?
  end
end

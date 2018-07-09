require 'test_helper'

class MovementTest < ActiveSupport::TestCase

  def setup
    @movement = movements(:movement1)
    @movement_parent = movements(:movement_div)
    @movement_child = movements(:movement_div1)
  end

  test 'Movements Model 001 - movement should be valid' do
    assert @movement.valid?
  end

  test 'Movements Model 002 - concept should be present' do
    @movement.concept = ""
    assert_not @movement.valid?
  end

  test 'Movements Model 003 - date should be present' do
    @movement.date = ""
    assert_not @movement.valid?
  end

  test 'Movements Model 004 - amount should be present' do
    @movement.amount = ""
    assert_not @movement.valid?
  end

  test 'Movements Model 005 - destroy movement should destroy association with statements' do
    assert_difference 'StatementMovement.count', -2 do
      assert_no_difference 'Statement.count'  do
        @movement.destroy
      end
    end
  end

  test 'Movements Model 006 - destroy movement should destroy association with apartment' do
    assert_difference 'ApartmentMovement.count', -1 do
      assert_no_difference 'Apartment.count'  do
        @movement.destroy
      end
    end
  end

  test 'Movements Model 007 - destroy movement should destroy associated children' do
    assert_difference 'MovementChild.count', -2 do
      assert_difference 'Movement.count', -3  do
        @movement_parent.destroy
      end
    end
  end

  test 'Movements Model 008 - destroy movement should destroy association with parent' do
    assert_difference 'MovementChild.count', -1 do
      assert_difference 'Movement.count', -1  do
        @movement_child.destroy
      end
    end
  end
end

require 'test_helper'

class MovementTest < ActiveSupport::TestCase

  #TODO nuevo test para los campos nuevos
  def setup
    @movement = movements(:ingreso1)
  end

  test 'Movements - movement should be valid' do
    assert @movement.valid?
  end

  test 'Movements - concept should be present' do
    @movement.concept = "";
    assert_not @movement.valid?
  end

  test 'Movements - date should be present' do
    @movement.date = "";
    assert_not @movement.valid?
  end

  test 'Movements - amount should be present' do
    @movement.amount = "";
    assert_not @movement.valid?
  end

  test 'Movements - destroy movement should destroy association with statements' do

  end

  test 'Movements - destroy movement should destroy association with apartment' do

  end

  test 'Movements - destroy movement should destroy associated children' do

  end

  test 'Movements - destroy movement should destroy association with parent' do

  end
end

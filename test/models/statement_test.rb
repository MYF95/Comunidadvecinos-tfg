require 'test_helper'

class StatementTest < ActiveSupport::TestCase
  def setup
    @statement = statements(:statement1)
    @statement2 = statements(:statement2)
  end

  test 'Statements Model 001 -  statement should be valid' do
    assert @statement.valid?
  end

  test 'Statements Model 002 -  name should be present' do
    @statement.name = ""
    assert_not @statement.valid?
  end

  test 'Statements Model 003 -  destroy statement should destroy association with movements and movements if association is unique' do
    assert_difference 'StatementMovement.count', -2 do
      assert_difference 'Movement.count', -1  do
        @statement.destroy
      end
    end
  end

  test 'Statements Model 004 -  destroy statement should destroy association with movements but not movements if association is not unique' do
    assert_no_difference 'Movement.count' do
      @statement2.destroy
    end
  end
end

require 'test_helper'

class StatementTest < ActiveSupport::TestCase
  def setup
    @statement = statements(:junio)
  end

  test 'statement should be valid' do
    assert @statement.valid?
  end

  test 'name should be present' do
    @statement.name = "";
    assert_not @statement.valid?
  end

  test 'date should be present' do
    @statement.date = "";
    assert_not @statement.valid?
  end
end

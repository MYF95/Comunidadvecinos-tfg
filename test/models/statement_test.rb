require 'test_helper'

class StatementTest < ActiveSupport::TestCase
  def setup
    @statement = statements(:junio)
  end

  test 'Statement - statement should be valid' do
    assert @statement.valid?
  end

  test 'Statement - name should be present' do
    @statement.name = "";
    assert_not @statement.valid?
  end

  test 'Statement - destroy statement should destroy association with movements and movements if association is unique' do

  end

  test 'Statement - destroy statement should destroy association with movements but not movements if association is not unique' do

  end


end

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  def setup
    @transaction = transactions(:ingreso1)
  end

  test 'transaction should be valid' do
    assert @transaction.valid?
  end

  test 'concept should be present' do
    @transaction.concept = "";
    assert_not @transaction.valid?
  end

  test 'date should be present' do
    @transaction.date = "";
    assert_not @transaction.valid?
  end

  test 'amount should be present' do
    @transaction.amount = "";
    assert_not @transaction.valid?
  end

  test 'amount should not be negative' do
    @transaction.amount = -1
    assert_not @transaction.valid?
  end
end

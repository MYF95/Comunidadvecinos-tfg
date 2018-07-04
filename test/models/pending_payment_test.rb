require 'test_helper'

class PendingPaymentTest < ActiveSupport::TestCase
  def setup
    @pending_payment = pending_payments(:cuota1a)
  end

  test 'pending payment should be valid' do
    assert @pending_payment.valid?
  end

  test 'concept should be present' do
    @pending_payment.concept = "";
    assert_not @pending_payment.valid?
  end

  test 'date should be present' do
    @pending_payment.date = "";
    assert_not @pending_payment.valid?
  end

  test 'amount should be present' do
    @pending_payment.amount = "";
    assert_not @pending_payment.valid?
  end

  test 'amount should not be negative' do
    @pending_payment.amount = -1
    assert_not @pending_payment.valid?
  end

  test 'months should be present' do
    @pending_payment.months = "";
    assert_not @pending_payment.valid?
  end

  test 'months should not be negative' do
    @pending_payment.months = -1
    assert_not @pending_payment.valid?
  end
end

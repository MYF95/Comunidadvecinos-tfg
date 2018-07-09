require 'test_helper'

class PendingPaymentTest < ActiveSupport::TestCase
  def setup
    @pending_payment = pending_payments(:pending_payment1)
  end

  test 'Pending Payments Model 001 - pending payment should be valid' do
    assert @pending_payment.valid?
  end

  test 'Pending Payments Model 002 - concept should be present' do
    @pending_payment.concept = ""
    assert_not @pending_payment.valid?
  end

  test 'Pending Payments Model 003 - date should be present' do
    @pending_payment.date = ""
    assert_not @pending_payment.valid?
  end

  test 'Pending Payments Model 004 - amount should be present' do
    @pending_payment.amount = ""
    assert_not @pending_payment.valid?
  end

  test 'Pending Payments Model 005 - amount should not be negative' do
    @pending_payment.amount = -1
    assert_not @pending_payment.valid?
  end

  test 'Pending Payments Model 006 - months should be present' do
    @pending_payment.months = ""
    assert_not @pending_payment.valid?
  end

  test 'Pending Payments Model 007 - months should not be negative' do
    @pending_payment.months = -1
    assert_not @pending_payment.valid?
  end

  test 'Pending Payments Model 008 - destroy pending payment should destroy association with apartments' do
    assert_difference 'ApartmentPendingPayment.count', -1 do
      assert_no_difference 'Apartment.count' do
        @pending_payment.destroy
      end
    end
  end
end

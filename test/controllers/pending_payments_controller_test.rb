require 'test_helper'

class PendingPaymentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @pending_payment = pending_payments(:cuota1a)

    @concept = 'Cuota de la vivienda 1ºB'
    @description = 'Cuota correspondiente de la vivienda 1ºB'
    @date = '27-06-2018'
  end

  # FUNCTIONS

  def assert_permissions
    assert_redirected_to root_path
    assert_select 'div', 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
  end

  # TESTS

  test 'should get new' do
    get new_pending_payment_path
    assert_response :success
  end

  test 'should get index' do
    get pending_payments_path
    assert_response :success
  end

  test 'should get correct pending payment' do
    get pending_payment_path(@pending_payment)
    assert_template 'pending_payments/show'
    assert_select 'p', "Concepto: #{@pending_payment.concept}"
  end

  # TODO Averiguar por qué los tests con usuarios no están funcionando

  # test 'create as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get new_pending_payment_path
  #   post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   assert_permissions
  # end
  #
  # test 'edit as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get edit_pending_payment_path(@pending_payment)
  #   assert_template 'pending_payments/edit'
  #   post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   assert_permissions
  # end
  #
  # test 'delete as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get pending_payment_path(@pending_payment)
  #   assert_no_difference 'PendingPayment.count' do
  #     delete pending_payment_path(@pending_payment)
  #   end
  #   assert_permissions
  # end
  #
  # test 'create pending payment should work properly as admin user' do
  #   log_in_as(@admin)
  #   get new_pending_payment_path
  #   assert_difference 'PendingPayment.count', 1 do
  #     post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   end
  #   follow_redirect!
  #   assert_template 'pending_payments/show'
  #   assert_not flash.empty?
  # end
  #
  # test 'update pending payment should work properly as admin user with correct data' do
  #   log_in_as(@admin)
  #   get edit_pending_payment_path(@pending_payment)
  #   binding.pry
  #   put pending_payments_path, params: { pending_payment: { concept: 'New concept', date: '28-06-2018', amount: '60', description: 'New description'}}
  #   assert_not flash.empty?
  #   assert_redirected_to @pending_payment
  #   @pending_payment.reload
  #   assert_equal 'New concept', @pending_payment.concept
  #   assert_equal '28-06-2018', @pending_payment.date
  #   assert_equal '60', @pending_payment.amount
  #   assert_equal 'New description', @pending_payment.description
  # end
  #
  # test 'update pending payment should not work as admin user with incorrect data' do
  #   log_in_as(@admin)
  #   get edit_pending_payment_path(@pending_payment)
  #   post pending_payments_path, params: { pending_payment: { concept: '', date: '', amount: '', description: ''}}
  #   assert_select 'div.alert', 'The form contains 4 errors.'
  # end
  #
  # test 'destroy pending payment should work properly as admin user' do
  #   log_in_as(@admin)
  #   get pending_payment_path(@pending_payment)
  #   assert_template 'pending_payments/show'
  #   assert_difference 'PendingPayment.count', -1 do
  #     delete pending_payment_path(@pending_payment)
  #   end
  #   assert_redirected_to pending_payments_path
  # end
end

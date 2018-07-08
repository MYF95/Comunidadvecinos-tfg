require 'test_helper'

class PendingPaymentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @pending_payment = pending_payments(:pending_payment1)

    @concept = 'Cuota de la vivienda 1ºB'
    @description = 'Cuota correspondiente de la vivienda 1ºB'
    @date = '27-06-2018'
  end

  #################
  #               #
  #   FUNCTIONS   #
  #               #
  #################

  def assert_permissions
    follow_redirect!
    assert_equal flash[:danger], 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
  end

  #############
  #           #
  #   TESTS   #
  #           #
  #############

  ##########
  # ROUTES #
  ##########

  test 'Pending Payments - should get index' do
    log_in_as(@user)
    get pending_payments_path
    assert_response :success
  end

  test 'Pending Payments - should get show' do
    log_in_as(@user)
    get pending_payment_path(@pending_payment)
    assert_template 'pending_payments/show'
    assert_select 'p', "Concepto"
  end

  # test 'Pending-Payments - new as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Pending Payments - edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_pending_payment_path(@pending_payment)
    post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_permissions
  end

  # test 'Pending Payments - apartments as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Pending Payments - new_all as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Pending Payments - should get new as admin' do
    log_in_as(@admin)
    get new_pending_payment_path
    assert_response :success
  end

  # test 'Pending Payments - should get edit as admin' do
  #
  # end
  #
  # test 'Pending Payments - should get new_all as admin' do
  #
  # end
  #
  # test 'Pending Payments - should get apartments as admin' do
  #
  # end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, edit, update, destroy, apartments, associate_apartment, new_all,
  # create_all
  #
  # permissions: index, show
  #
  # actions: create, update, destroy, add_user, associate_apartment, create_all

  test 'Pending Payments - create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_pending_payment_path
    post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_permissions
  end

  # test 'Pending Payments - create pending payment should work with correct data as admin' do
  #   log_in_as(@admin)
  #   get new_pending_payment_path
  #   assert_difference 'PendingPayment.count', 1 do
  #     post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   end
  #   follow_redirect!
  #   assert_template 'pending_payments/show'
  #   assert_not flash.empty?
  # end

  # test 'Pending Payments - create pending payment should not work with incorrect data' do
  #
  # end
  #
  # test 'Pending Payments - create pending payment should not work with no apartments created' do
  #
  # end
  #
  # test 'Pending Payments - update as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Pending Payments - update pending payment should work properly as admin user with correct data' do
    log_in_as(@admin)
    get edit_pending_payment_path(@pending_payment)
    patch pending_payment_path(@pending_payment), params: { pending_payment: { concept: 'New concept', date: '28-06-2018', amount: '60', description: 'New description'}}
    assert_not flash.empty?
    assert_redirected_to @pending_payment
    @pending_payment.reload
    assert_equal 'New concept', @pending_payment.concept
    assert_equal '28-06-2018', @pending_payment.date.strftime("%d-%m-%Y")
    assert_equal 60, @pending_payment.amount
    assert_equal 'New description', @pending_payment.description
  end

  test 'Pending Payments - update pending payment should not work as admin user with incorrect data' do
    log_in_as(@admin)
    get edit_pending_payment_path(@pending_payment)
    patch pending_payment_path(@pending_payment), params: { pending_payment: { concept: '', date: '', amount: '', description: ''}}
    assert_select 'div.form-alert', 'El formulario contiene algunos errores.'
  end

  test 'Pending Payments - delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get pending_payment_path(@pending_payment)
    assert_no_difference 'PendingPayment.count' do
      delete pending_payment_path(@pending_payment)
    end
    assert_permissions
  end

  test 'Pending Payments - destroy pending payment should work properly as admin user' do
    log_in_as(@admin)
    get pending_payment_path(@pending_payment)
    assert_template 'pending_payments/show'
    assert_difference 'PendingPayment.count', -1 do
      delete pending_payment_path(@pending_payment)
    end
    assert_redirected_to pending_payments_path
  end

  # test 'Pending Payments - associate_apartment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Pending Payments - associate_apartment should work moving to another apartment correctly as admin' do
  #
  # end
  #
  # test 'Pending Payments - create_all as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Pending Payments - create_all pending payments should work with correct data as admin user' do
  #
  # end
  #
  # test 'Pending Payments - create_all pending payments should not work with incorrect data' do
  #
  # end
  #
  # test 'Pending Payments - create_all pending payments should not work if there are not apartments created' do
  #
  # end
  #
  # test 'Pending Payments - create_all pending payments should not work if apartments contribution fee do not sum to 1 or there are apartments with 0 contribution fee' do
  #
  # end
end

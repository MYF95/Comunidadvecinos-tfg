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

  test 'Pending Payments Controller 001 -  should get index' do
    log_in_as(@user)
    get pending_payments_path
    assert_response :success
  end

  test 'Pending Payments Controller 002 -  should get show' do
    log_in_as(@user)
    get pending_payment_path(@pending_payment)
    assert_template 'pending_payments/show'
    assert_select 'h1', 'Datos del pago pendiente'
  end

  test 'Pending Payments Controller 003 - new as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_pending_payment_path
    assert_permissions
  end

  test 'Pending Payments Controller 004 -  edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_pending_payment_path(@pending_payment)
    assert_permissions
  end

  test 'Pending Payments Controller 005 -  apartments as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get pending_payment_apartment_list_path(@pending_payment)
    assert_permissions
  end

  test 'Pending Payments Controller 006 -  new_all as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get pending_payment_new_all_path
    assert_permissions
  end

  test 'Pending Payments Controller 007 -  should get new as admin' do
    log_in_as(@admin)
    get new_pending_payment_path
    assert_response :success
  end

  test 'Pending Payments Controller 008 -  should get edit as admin' do
    log_in_as(@admin)
    get edit_pending_payment_path(@pending_payment)
    assert_response :success
  end

  test 'Pending Payments Controller 009 -  should get new_all as admin' do
    log_in_as(@admin)
    get pending_payment_new_all_path
    assert_response :success
  end

  test 'Pending Payments Controller 010 -  should get apartments as admin' do
    log_in_as(@admin)
    get pending_payment_apartment_list_path(@pending_payment)
    assert_response :success
  end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, edit, update, destroy, apartments, associate_apartment, new_all,
  # create_all
  #
  # permissions: index, show
  #
  # actions: create, update, destroy, add_user, associate_apartment, create_all

  test 'Pending Payments Controller 011 -  create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_pending_payment_path
    post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_permissions
  end

  # test 'Pending Payments Controller 012 -  create pending payment should work with correct data as admin' do
  #   log_in_as(@admin)
  #   get new_pending_payment_path
  #   assert_difference 'PendingPayment.count', 1 do
  #     post pending_payments_path, params: { pending_payment: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   end
  #   follow_redirect!
  #   assert_template 'pending_payments/show'
  #   assert_not flash.empty?
  # end

  # test 'Pending Payments Controller 013 -  create pending payment should not work with incorrect data' do
  #
  # end
  #
  # test 'Pending Payments Controller 014 -  create pending payment should not work with no apartments created' do
  #
  # end
  #
  # test 'Pending Payments Controller 015 -  update as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Pending Payments Controller 016 -  update pending payment should work properly as admin user with correct data' do
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

  test 'Pending Payments Controller 017 -  update pending payment should not work as admin user with incorrect data' do
    log_in_as(@admin)
    get edit_pending_payment_path(@pending_payment)
    patch pending_payment_path(@pending_payment), params: { pending_payment: { concept: '', date: '', amount: '', description: ''}}
    assert_select 'div.form-alert', 'El formulario contiene algunos errores.'
  end

  test 'Pending Payments Controller 018 -  delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get pending_payment_path(@pending_payment)
    assert_no_difference 'PendingPayment.count' do
      delete pending_payment_path(@pending_payment)
    end
    assert_permissions
  end

  test 'Pending Payments Controller 019 -  destroy pending payment should work properly as admin user' do
    log_in_as(@admin)
    get pending_payment_path(@pending_payment)
    assert_template 'pending_payments/show'
    assert_difference 'PendingPayment.count', -1 do
      delete pending_payment_path(@pending_payment)
    end
    assert_redirected_to pending_payments_path
  end

  # test 'Pending Payments Controller 020 -  associate_apartment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Pending Payments Controller 021 -  associate_apartment should work moving to another apartment correctly as admin' do
  #
  # end
  #
  # test 'Pending Payments Controller 022 -  create_all as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Pending Payments Controller 023 -  create_all pending payments should work with correct data as admin user' do
  #
  # end
  #
  # test 'Pending Payments Controller 024 -  create_all pending payments should not work with incorrect data' do
  #
  # end
  #
  # test 'Pending Payments Controller 025 -  create_all pending payments should not work if there are not apartments created' do
  #
  # end
  #
  # test 'Pending Payments Controller 026 -  create_all pending payments should not work if apartments contribution fee do not sum to 1 or there are apartments with 0 contribution fee' do
  #
  # end
end

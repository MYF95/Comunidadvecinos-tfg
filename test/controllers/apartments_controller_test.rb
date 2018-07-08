require 'test_helper'

class ApartmentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @apartment = apartments(:primero)
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

  test 'Apartments - should get index' do
    log_in_as(@user)
    get apartments_path
    assert_response :success
  end

  # test 'Apartments - should show user apartments only if not admin' do
  #
  # end

  test 'Apartments - should get show' do
    log_in_as(@user)
    get apartment_path(@apartment)
    assert_template 'apartments/show'
    assert_select 'h1', "Datos de la vivienda #{full_name_apartment @apartment}"
  end

  # test 'Apartments - should get users' do
  #
  # end
  #
  # test 'Apartments - should get movements' do
  #
  # end
  #
  # test 'Apartments - should get pending_payments' do
  #
  # end
  #
  # test 'Apartments - should get history' do
  #
  # end
  #
  # test 'Apartments - new as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Apartments - edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_apartment_path(@apartment)
    post apartments_path, params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    assert_permissions
  end

  # test 'Apartments - pending_payments_users as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Apartments - should get new as admin' do
    log_in_as(@admin)
    get new_apartment_path
    assert_response :success
  end

  # test 'Apartments - should get pending_payment_users as admin' do
  #
  # end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, edit, update, destroy, users, add_user, remove_user, add_owner,
  # remove_owner, movements, history, pending_payments, pending_payments_users, pay_pending_payment
  #
  # permissions: index, show, users, pending_payments, movements, history
  #
  # actions: create, update, destroy, add_user, remove_user, add_owner, remove_owner, pay_pending_payment

  test 'Apartments - create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_apartment_path
    post apartments_path, params: { apartment: { floor: '1', letter: 'B', fee: '60', apartment_contribution: 0.15}}
    assert_permissions
  end

  test 'Apartments - create apartment should work with correct data as admin' do
    log_in_as(@admin)
    get new_apartment_path
    assert_difference 'Apartment.count', 1 do
      post apartments_path, params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    end
    follow_redirect!
    assert_template 'apartments/show'
    assert_not flash.empty?
  end

  # test 'Apartments - create apartment should not work with incorrect data' do
  #
  # end
  #
  # test 'Apartments - create apartment should not work if apartment floor and letter is already taken' do
  #
  # end
  #
  # test 'Apartments - create apartment should set new apartment_contribution to 0 if total would surpass 1 as admin' do
  #
  # end
  #
  # test 'Apartments - update as non-admin user should redirect to homepage with message' do
  #
  # end

  test 'Apartments - update apartment should work with correct data as admin' do
    log_in_as(@admin)
    get edit_apartment_path(@apartment)
    patch apartment_path(@apartment), params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    assert_not flash.empty?
    assert_redirected_to @apartment
    @apartment.reload
    assert_equal 1, @apartment.floor
    assert_equal 'B', @apartment.letter
    assert_equal 60, @apartment.fee
  end

  test 'Apartments - update apartment should not work with incorrect data' do
    log_in_as(@admin)
    get edit_apartment_path(@apartment)
    patch apartment_path(@apartment), params: { apartment: { floor: '', letter: '', fee: '' }}
    assert_select 'div.form-alert', 'El formulario contiene algunos errores.'
  end

  # test 'Apartments - update apartment should not work if total_apartment_contribution surpasses 1' do
  #
  # end
  #
  # test 'Apartments - update apartment should not work if new floor and letter is taken' do
  #
  # end

  test 'Apartments - delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get apartment_path(@apartment)
    assert_no_difference 'Apartment.count' do
      delete apartment_path(@apartment)
    end
    assert_permissions
  end

  test 'Apartments - destroy apartment should work as admin' do
    log_in_as(@admin)
    get apartment_path(@apartment)
    assert_template 'apartments/show'
    assert_difference 'Apartment.count', -1 do
      delete apartment_path(@apartment)
    end
    assert_redirected_to apartments_path
  end

  # test 'Apartments - add_user as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Apartments - remove_user as non-admin user should redirect to homepage with message' do
  #
  # end

  # test 'Apartments - add_user should work if user is not in the apartment as admin' do
  #
  # end
  #
  # test 'Apartments - add_user should not work if user is already associated with apartment' do
  #
  # end
  #
  # test 'Apartments - remove_user should work if chosen user is in the apartment as admin' do
  #
  # end
  #
  # test 'Apartments - remove_user should not work if chosen user is owner of apartment' do
  #
  # end
  #
  # test 'Apartments - remove_user should not work if chosen user is not in the apartment' do
  #
  # end
  #
  # test 'Apartments - add_owner as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Apartments - remove_owner as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Apartments - add_owner should work for chosen user if there was no owner previously as admin' do
  #
  # end
  #
  # test 'Apartments - add_owner should work if chosen user was already in the apartment as admin' do
  #
  # end
  #
  # test 'Apartments - add_owner should not work if there is already an owner in the apartment' do
  #
  # end
  #
  # test 'Apartments - remove_owner should work for chosen user as admin' do
  #
  # end
  #
  # test 'Apartments - remove_owner should not work if you do not choose the owner' do
  #
  # end
  #
  # test 'Apartments - pay_pending_payment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # # ADD balance checker to this test
  # test 'Apartments - pay_pending_payments should work as admin' do
  #
  # end
  #
  # test 'Apartments - pay_pending_payments should not work if chosen pending payment is not the oldest' do
  #
  # end
  #
  # test 'Apartments - pay_pending_payments should not work if apartment does not have enough balance to pay' do
  #
  # end
end

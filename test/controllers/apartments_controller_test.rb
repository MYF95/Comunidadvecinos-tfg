require 'test_helper'

class ApartmentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @approved = users(:approved)
    @apartment = apartments(:apartment1)
    @other_apartment = apartments(:apartment2)
    @movement = movements(:movement3)
    @pending_payment = pending_payments(:pending_payment1)
    @other_pending_payment = pending_payments(:pending_payment2)
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

  def balance_checker
    balance = 0
    @apartment.movements.all.each do |movement|
      balance += movement.amount
    end
    @apartment.pending_payments.all.each do |pending_payment|
      balance -= pending_payment.amount if pending_payment.paid?
    end
    @apartment.balance = balance
  end

  #############
  #           #
  #   TESTS   #
  #           #
  #############

  ##########
  # ROUTES #
  ##########

  test 'Apartments Controller 001 - should get index' do
    log_in_as(@user)
    get apartments_path
    assert_response :success
  end

  test 'Apartments Controller 002 - should show user apartments only if user is not admin' do
    log_in_as(@user)
    apartments = @user.apartments.count
    get apartments_path
    assert_select "table" do |elements|
      assert_select elements, 'tr', apartments + 1
    end
  end

  test 'Apartments Controller 003 - show as admin should get all apartments' do
    log_in_as(@admin)
    apartments = Apartment.all.count
    get apartments_path
    assert_select "table" do |elements|
      assert_select elements, 'tr', apartments + 1
    end
  end

  test 'Apartments Controller 004 - should get show' do
    log_in_as(@user)
    get apartment_path(@apartment)
    assert_template 'apartments/show'
    assert_select 'h1', "Datos de la vivienda #{full_name_apartment @apartment}"
  end

  test 'Apartments Controller 005 - should get users' do
    log_in_as(@user)
    get apartment_users_path(@apartment)
    assert_template 'apartments/users'
    assert_select 'h1', "Usuarios de la vivienda #{full_name_apartment @apartment}"
  end

  test 'Apartments Controller 006 - should get movements' do
    log_in_as(@user)
    get apartment_movements_path(@apartment)
    assert_template 'apartments/movements'
    assert_select 'h1', "Movimientos asociados a la vivienda #{full_name_apartment @apartment}"
  end

  test 'Apartments Controller 007 - should get pending_payments' do
    log_in_as(@user)
    get apartment_pending_payments_path(@apartment)
    assert_template 'apartments/pending_payments'
    assert_select 'h1', "Pagos pendientes de la vivienda #{full_name_apartment @apartment}"
  end

  test 'Apartments Controller 008 - should get history' do
    log_in_as(@user)
    get apartment_history_path(@apartment)
    assert_template 'apartments/history'
    assert_select 'h1', "Contabilidad de pagos de la vivienda #{full_name_apartment @apartment}"
  end

  test 'Apartments Controller 009 - new as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_apartment_path(@apartment)
    assert_permissions
  end

  test 'Apartments Controller 010 - edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_apartment_path(@apartment)
    post apartments_path, params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    assert_permissions
  end

  test 'Apartments Controller 011 - pending_payments_users as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get pending_payment_users_path(@apartment, @pending_payment)
    assert_permissions
  end

  test 'Apartments Controller 012 - should get new as admin' do
    log_in_as(@admin)
    get new_apartment_path
    assert_response :success
  end

  test 'Apartments Controller 013 - should get edit as admin' do
    log_in_as(@admin)
    get edit_apartment_path(@apartment)
    assert_response :success
  end

  test 'Apartments Controller 014 - should get pending_payment_users as admin' do
    log_in_as(@admin)
    get edit_apartment_path(@apartment, @pending_payment)
    assert_response :success
  end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, edit, update, destroy, users, add_user, remove_user, add_owner,
  # remove_owner, movements, history, pending_payments, pending_payments_users, pay_pending_payment
  #
  # permissions: index, show, users, pending_payments, movements, history
  #
  # actions: create, update, destroy, add_user, remove_user, add_owner, remove_owner, pay_pending_payment

  test 'Apartments Controller 015 - create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'Apartment.count' do
      post apartments_path, params: { apartment: { floor: '1', letter: 'B', fee: '60', apartment_contribution: 0.15}}
    end
    assert_permissions
  end

  test 'Apartments Controller 016 - create apartment should work with correct data as admin' do
    log_in_as(@admin)
    assert_difference 'Apartment.count', 1 do
      post apartments_path, params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    end
    follow_redirect!
    assert_template 'apartments/show'
    assert_not flash.empty?
  end

  test 'Apartments Controller 017 - create apartment should not work with incorrect data' do
    log_in_as(@admin)
    assert_no_difference 'Apartment.count' do
      post apartments_path, params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: -1}}
    end
    assert_template 'apartments/new'
    assert_select 'div.form-alert', 'El formulario contiene algunos errores.'
  end

  test 'Apartments Controller 018 - create apartment should set new apartment_contribution to 0 if total would surpass 1 as admin' do
    log_in_as(@admin)
    assert_difference 'Apartment.count', 1 do
      post apartments_path, params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 1}}
    end
    follow_redirect!
    assert_template 'apartments/edit'
    assert_equal flash[:info], "La vivienda #{full_name_apartment(Apartment.last)} ha sido creada, pero la contribución de la cuota supera el máximo de la comunidad. Por favor, actualiza el valor de la contribución."
    assert_equal 0, Apartment.last.apartment_contribution
  end

  test 'Apartments Controller 019 - update as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    patch apartment_path(@apartment), params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    assert_permissions
  end

  test 'Apartments Controller 020 - update apartment should work with correct data as admin' do
    log_in_as(@admin)
    patch apartment_path(@apartment), params: { apartment: { floor: 1, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    assert_not flash.empty?
    assert_redirected_to @apartment
    @apartment.reload
    assert_equal 1, @apartment.floor
    assert_equal 'B', @apartment.letter
    assert_equal 60, @apartment.fee
    assert_equal 0.15, @apartment.apartment_contribution
  end

  test 'Apartments Controller 021 - update apartment should not work with incorrect data' do
    log_in_as(@admin)
    patch apartment_path(@apartment), params: { apartment: { floor: '', letter: '', fee: '', apartment_contribution: '' }}
    assert_select 'div.form-alert', 'El formulario contiene algunos errores.'
  end

  test 'Apartments Controller 022 - update apartment should not work if total_apartment_contribution surpasses 1' do
    log_in_as(@admin)
    patch apartment_path(@apartment), params: { apartment: { floor: 1, letter: 'A', fee: 60, apartment_contribution: 1}}
    assert_equal flash[:danger], "La contribución que intentas poner en la vivienda #{full_name_apartment(@apartment)} supera el máximo."
    follow_redirect!
    assert_template 'apartments/edit'
  end

  test 'Apartments Controller 023 - update apartment should not work if new floor and letter is taken' do
    log_in_as(@admin)
    patch apartment_path(@apartment), params: { apartment: { floor: 2, letter: 'B', fee: 60, apartment_contribution: 0.15}}
    assert_equal flash[:danger], "Ya hay una vivienda con ese piso y letra, elige otro."
    assert_template 'apartments/edit'
  end

  test 'Apartments Controller 024 - delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'Apartment.count' do
      delete apartment_path(@apartment)
    end
    assert_permissions
  end

  test 'Apartments Controller 025 - destroy apartment should work as admin' do
    log_in_as(@admin)
    assert_difference 'Apartment.count', -1 do
      delete apartment_path(@apartment)
    end
    assert_redirected_to apartments_path
  end

  test 'Apartments Controller 026 - add_user as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'UserApartment.count' do
      get add_user_path(@other_apartment, @user)
    end
    assert_permissions
  end

  test 'Apartments Controller 027 - add_user should work if user is not in the apartment as admin' do
    log_in_as(@admin)
    assert_difference 'UserApartment.count', 1 do
      get add_user_path(@other_apartment, @user)
    end
    assert_equal @other_apartment.users.last, @user
    assert_equal flash[:info], "#{@user.first_name} añadido a la vivienda"
  end

  test 'Apartments Controller 028 - add_user should not work if user is already associated with apartment' do
    log_in_as(@admin)
    assert_no_difference 'UserApartment.count' do
      get add_user_path(@apartment, @user)
    end
    assert_equal flash[:danger], 'El usuario ya está en la vivienda'
  end

  test 'Apartments Controller 029 - remove_user as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'UserApartment.count' do
      delete remove_user_path(@other_apartment, @user)
    end
    assert_permissions
  end

  test 'Apartments Controller 030 - remove_user should work for non-owner user in apartment as admin' do
    log_in_as(@admin)
    assert_difference 'UserApartment.count', -1 do
      delete remove_user_path(@apartment, @admin)
    end
    assert_equal flash[:info], "#{@admin.first_name} ha sido quitado de la vivienda"
  end

  test 'Apartments Controller 031 - remove_user should not work if chosen user is owner of apartment' do
    log_in_as(@admin)
    assert_no_difference 'UserApartment.count' do
      delete remove_user_path(@apartment, @user)
    end
    assert_equal flash[:danger], 'El usuario que intentas quitar es el propietario. Desasígnalo como propietario antes de quitarlo de la vivienda.'
    assert_includes @apartment.users, @user
  end

  test 'Apartments Controller 032 - remove_user should not work if chosen user is not in the apartment' do
    log_in_as(@admin)
    assert_no_difference 'UserApartment.count' do
      delete remove_user_path(@apartment, @approved)
    end
    assert_equal flash[:danger], "#{@approved.first_name} no está en la vivienda"
  end

  test 'Apartments Controller 033 - add_owner as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'ApartmentOwner.count' do
      get add_owner_path(@other_apartment, @user)
    end
    assert_permissions
  end

  test 'Apartments Controller 034 - add_owner should work for chosen user if there was no owner previously as admin' do
    log_in_as(@admin)
    assert_difference 'ApartmentOwner.count', 1 do
      get add_owner_path(@other_apartment, @user)
    end
    assert_equal @other_apartment.owner, @user
    assert_equal flash[:info], "#{@user.first_name} añadido a la vivienda"
  end

  test 'Apartments Controller 035 - add_owner should work if chosen user was already in the apartment as admin' do
    log_in_as(@admin)
    get add_user_path(@other_apartment, @user)
    assert_includes @other_apartment.users, @user
    assert_difference 'ApartmentOwner.count', 1 do
      get add_owner_path(@other_apartment, @user)
    end
    assert_equal @other_apartment.owner, @user
    assert_equal flash[:info], 'El usuario ya estaba en la vivienda y se ha añadido como propietario.'
  end

  test 'Apartments Controller 036 - add_owner should not work if there is already an owner in the apartment' do
    log_in_as(@admin)
    assert_no_difference 'ApartmentOwner.count' do
      get add_owner_path(@apartment, @admin)
    end
    assert_not_equal @apartment.owner, @admin
    assert_equal flash[:danger], 'La vivienda ya tiene un propietario. Si quieres cambiar de propietario a la vivienda, desasocia el propietario primero para asegurar que quieres realizar la acción.'
  end

  test 'Apartments Controller 037 - remove_owner as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'ApartmentOwner.count' do
      delete remove_owner_path(@apartment, @user)
    end
    assert_permissions
  end

  test 'Apartments Controller 038 - remove_owner should work for chosen user as admin' do
    log_in_as(@admin)
    assert_difference 'ApartmentOwner.count', -1  do
      delete remove_owner_path(@apartment)
    end
    assert_not_equal @apartment.owner, @user
    assert_equal flash[:info], "Se ha quitado a #{@user.first_name} como propietario de la vivienda."
  end

  test 'Apartments Controller 039 - pay_pending_payment as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    assert_no_difference 'PendingPayment.where(paid: true).count' do
      get pay_pending_payment_path(@apartment, @pending_payment, @user)
    end
    assert_permissions
  end

  test 'Apartments Controller 040 - pay_pending_payments should work as admin' do
    log_in_as(@admin)
    balance_checker
    balance = @apartment.balance
    assert_difference 'PendingPayment.where(paid: true).count', 1 do
      get pay_pending_payment_path(@apartment, @pending_payment, @user)
    end
    balance_checker
    assert_equal flash[:info], "Se ha pagado el pago pendiente '#{@pending_payment.concept}'"
    assert_equal @apartment.balance, balance - @pending_payment.amount
  end

  test 'Apartments Controller 041 - pay_pending_payments should not work if chosen pending payment is not the oldest' do
    log_in_as(@admin)
    @apartment.apartment_pending_payments.create!(apartment: @apartment, pending_payment: @other_pending_payment)
    balance_checker
    balance = @apartment.balance
    assert_no_difference 'PendingPayment.where(paid: true).count' do
      get pay_pending_payment_path(@apartment, @pending_payment, @user)
    end
    balance_checker
    oldest_pending_payment = @apartment.pending_payments.all.where(paid: false).order('date asc').first
    assert_equal flash[:danger], "El pago pendiente que intentas pagar no es el más antiguo de la vivienda. Por favor, paga primero '#{oldest_pending_payment.concept}'"
    assert_equal @apartment.balance, balance
  end

  test 'Apartments Controller 042 - pay_pending_payments should not work if apartment does not have enough balance to pay' do
    log_in_as(@admin)
    @apartment.movements.destroy_all
    @apartment.apartment_movements.create!(apartment: @apartment, movement: @movement)
    balance_checker
    balance = @apartment.balance
    assert_no_difference 'PendingPayment.where(paid: true).count' do
      get pay_pending_payment_path(@apartment, @pending_payment, @user)
    end
    balance_checker
    assert_equal flash[:danger], "La vivienda #{full_name_apartment(@apartment)} no tiene suficiente saldo para pagar el pago pendiente"
    assert_equal @apartment.balance, balance
  end
end

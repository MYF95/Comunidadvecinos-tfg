require 'test_helper'

class MovementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @movement = movements(:movement1)
    @statement = statements(:statement1)

    @concept = 'Ingreso de ponsan'
    @description = 'Ingreso de Ponsan de la vivienda 1ºA'
    @date = '23-06-2018'
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

  test 'Movements Controller 001 - should get index' do
    log_in_as(@user)
    get movements_path
    assert_response :success
  end

  test 'Movements Controller 002 - should get show' do
    log_in_as(@user)
    get movement_path(@movement)
    assert_template 'movements/show'
    assert_select 'h1', 'Datos del movimiento bancario'
  end

  test 'Movements Controller 003 - new as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_movement_path
    assert_permissions
  end

  test 'Movements Controller 004 - edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_movement_path(@movement)
    assert_permissions
  end

  test 'Movements Controller 005 - divide as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get divide_path(@movement)
    assert_permissions
  end

  test 'Movements Controller 006 - apartments as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get apartmentlist_path(@movement)
    assert_permissions
  end

  test 'Movements Controller 007 - should get new as admin' do
    log_in_as(@admin)
    get new_movement_path
    assert_response :success
  end

  test 'Movements Controller 008 - should get edit as admin' do
    log_in_as(@admin)
    get edit_movement_path(@movement)
    assert_response :success
  end

  test 'Movements Controller 009 - should get divide as admin' do
    log_in_as(@admin)
    get divide_path(@movement)
    assert_response :success
  end

  test 'Movements Controller 010 - should get apartments as admin' do
    log_in_as(@admin)
    get apartmentlist_path(@movement)
    assert_response :success
  end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, edit, update, destroy, divide, divide_movement,
  # apartments, associate_apartment, remove_apartment, children
  #
  # permissions: index, show, children
  #
  # actions: create, update, destroy, divide_movement, associate_apartment, remove_apartment


  test 'Movements Controller 011 - create movement should redirect to homepage with message' do
    log_in_as(@user)
    get new_movement_path
    post movements_path, params: { movement: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_equal flash[:danger], 'Esta operación no está permitida'
  end

  test 'Movements Controller 012 - update movement should work properly as admin' do
    log_in_as(@admin)
    get edit_movement_path(@movement)
    patch movement_path(@movement), params: { movement: {description: 'New description'}}
    assert_not flash.empty?
    assert_redirected_to @movement
    @movement.reload
    assert_equal 'New description', @movement.description
  end

  test 'Movements Controller 013 - delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get movement_path(@movement)
    assert_no_difference 'Movement.count' do
      delete movement_path(@movement)
    end
    assert_permissions
  end

  test 'Movements Controller 014 - destroy movement should work properly as admin' do
    log_in_as(@admin)
    get movement_path(@movement)
    assert_template 'movements/show'
    assert_difference 'Movement.count', -1 do
      delete movement_path(@movement)
    end
    assert_redirected_to movements_path
  end

  # test 'Movements Controller 015 - divide_movement as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Movements Controller 016 - divide_movement should work with correct data as admin' do
  #
  # end
  #
  # test 'Movements Controller 017 - divide_movement should not work with negative or bigger than current amount' do
  #
  # end
  #
  # test 'Movements Controller 018 - divide_movement should not work if the movement is associated to an apartment' do
  #
  # end
  #
  # test 'Movements Controller 019 - associate_apartment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Movements Controller 020 - associate_apartment should work correctly as admin' do
  #
  # end
  #
  # test 'Movements Controller 021 - remove_apartment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Movements Controller 022 - remove_apartment should work correctly as admin' do
  #
  # end
end

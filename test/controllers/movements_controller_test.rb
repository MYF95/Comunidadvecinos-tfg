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

  test 'Movements - should get index' do
    log_in_as(@user)
    get movements_path
    assert_response :success
  end

  test 'Movements - should get show' do
    log_in_as(@user)
    get movement_path(@movement)
    assert_template 'movements/show'
    assert_select 'h1', 'Datos del movimiento bancario'
  end

  test 'Movements - new as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_movement_path
    assert_permissions
  end

  test 'Movements - edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_movement_path(@movement)
    assert_permissions
  end

  test 'Movements - divide as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get divide_path(@movement)
    assert_permissions
  end

  test 'Movements - apartments as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get apartmentlist_path(@movement)
    assert_permissions
  end

  test 'Movements - should get new as admin' do
    log_in_as(@admin)
    get new_movement_path
    assert_response :success
  end

  test 'Movements - should get edit as admin' do
    log_in_as(@admin)
    get edit_movement_path(@movement)
    assert_response :success
  end

  test 'Movements - should get divide as admin' do
    log_in_as(@admin)
    get divide_path(@movement)
    assert_response :success
  end

  test 'Movements - should get apartments as admin' do
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


  test 'Movements - create movement should redirect to homepage with message' do
    log_in_as(@user)
    get new_movement_path
    post movements_path, params: { movement: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_equal flash[:danger], 'Esta operación no está permitida actualmente'
  end

  test 'Movements - update movement should work properly as admin' do
    log_in_as(@admin)
    get edit_movement_path(@movement)
    patch movement_path(@movement), params: { movement: {description: 'New description'}}
    assert_not flash.empty?
    assert_redirected_to @movement
    @movement.reload
    assert_equal 'New description', @movement.description
  end

  test 'Movements - delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get movement_path(@movement)
    assert_no_difference 'Movement.count' do
      delete movement_path(@movement)
    end
    assert_permissions
  end

  test 'Movements - destroy movement should work properly as admin' do
    log_in_as(@admin)
    get movement_path(@movement)
    assert_template 'movements/show'
    assert_difference 'Movement.count', -1 do
      delete movement_path(@movement)
    end
    assert_redirected_to movements_path
  end

  # test 'Movements - divide_movement as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Movements - divide_movement should work with correct data as admin' do
  #
  # end
  #
  # test 'Movements - divide_movement should not work with negative or bigger than current amount' do
  #
  # end
  #
  # test 'Movements - divide_movement should not work if the movement is associated to an apartment' do
  #
  # end
  #
  # test 'Movements - associate_apartment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # #TODO associate_apartment might be too big, there are many things that have to happen to work
  # test 'Movements - associate_apartment should work correctly as admin' do
  #
  # end
  #
  # test 'Movements - remove_apartment as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Movements - remove_apartment should work correctly as admin' do
  #
  # end
end

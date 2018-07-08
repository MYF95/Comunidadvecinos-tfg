require 'test_helper'

class MovementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @movement = movements(:ingreso1)
    @statement = statements(:junio)

    @concept = 'Ingreso de ponsan'
    @description = 'Ingreso de Ponsan de la vivienda 1ºA'
    @date = '23-06-2018'
  end

  # FUNCTIONS

  def assert_permissions
    follow_redirect!
    assert_equal flash[:danger], 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
  end

  # TESTS

  test 'should get new' do
    log_in_as(@admin)
    get new_movement_path
    assert_response :success
  end

  test 'should get index' do
    log_in_as(@user)
    get movements_path
    assert_response :success
  end

  test 'should get correct movement' do
    log_in_as(@user)
    get movement_path(@movement)
    assert_template 'movements/show'
    assert_select 'h1', 'Datos del movimiento bancario'
  end

  test 'create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_movement_path
    post movements_path, params: { movement: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_permissions
  end

  test 'edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_movement_path(@movement)
    post movements_path, params: { movement: { concept: @concept, date: @date, amount: '50', description: @description}}
    assert_permissions
  end

  test 'delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get movement_path(@movement)
    assert_no_difference 'Movement.count' do
      delete movement_path(@movement)
    end
    assert_permissions
  end

  #TODO remove create movement
  # test 'create movement should work properly as admin user' do
  #   log_in_as(@admin)
  #   get new_movement_path
  #   assert_difference 'Movement.count', 1 do
  #     post movements_path, params: { movement: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   end
  #   follow_redirect!
  #   assert_template 'movements/show'
  #   assert_not flash.empty?
  # end

  test 'update movement should work properly as admin user with correct data' do
    log_in_as(@admin)
    get edit_movement_path(@movement)
    patch movement_path(@movement), params: { movement: {description: 'New description'}}
    assert_not flash.empty?
    assert_redirected_to @movement
    @movement.reload
    assert_equal 'New description', @movement.description
  end

  test 'destroy movement should work properly as admin user' do
    log_in_as(@admin)
    get movement_path(@movement)
    assert_template 'movements/show'
    assert_difference 'Movement.count', -1 do
      delete movement_path(@movement)
    end
    assert_redirected_to movements_path
  end

  #TODO tests para crear un extracto, dividir un movimiento, asociar un movimiento a una vivienda

  # test 'create for statement' do
  # end
  #
  # test 'divide movement' do
  # end
  #
  # test 'associate apartment' do
  # end
  #
  # test 'remove apartment' do
  # end
  #
  # test 'children' do
  # end
end

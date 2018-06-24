require 'test_helper'

class MovementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @movement = transactions(:ingreso1)

    @concept = 'Ingreso de ponsan'
    @description = 'Ingreso de Ponsan de la vivienda 1ºA'
    @date = '23-06-2018'
  end

  # FUNCTIONS

  def assert_permissions
    assert_redirected_to root_path
    assert_select 'div', 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
  end

  # TESTS

  test 'should get new' do
    get new_transaction_path
    assert_response :success
  end

  test 'should get index' do
    get transactions_path
    assert_response :success
  end

  test 'should get correct @movement' do
    get transaction_path(@movement)
    assert_template 'movements/show'
    assert_select 'h1', "Datos del movimiento bancario #{@movement.concept}"
  end

  # TODO Averiguar por qué los tests con usuarios no están funcionando

  # test 'create as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get new_transaction_path
  #   post transactions_path, params: { @movement: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   assert_permissions
  # end
  #
  # test 'edit as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get edit_transaction_path(@@movement)
  #   assert_template 'movements/edit'
  #   post transactions_path, params: { @movement: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   assert_permissions
  # end
  #
  # test 'delete as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get transaction_path(@@movement)
  #   assert_no_difference 'Movement.count' do
  #     delete transaction_path(@@movement)
  #   end
  #   assert_permissions
  # end
  #
  # test 'create @movement should work properly as admin user' do
  #   log_in_as(@admin)
  #   get new_transaction_path
  #   assert_difference 'Movement.count', 1 do
  #     post transactions_path, params: { @movement: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   end
  #   follow_redirect!
  #   assert_template 'movements/show'
  #   assert_not flash.empty?
  # end
  #
  # test 'update @movement should work properly as admin user with correct data' do
  #   log_in_as(@admin)
  #   get edit_transaction_path(@@movement)
  #   binding.pry
  #   put transactions_path, params: { @movement: { concept: 'New @movement', date: '28-06-2018', amount: '60', description: 'New description'}}
  #   assert_not flash.empty?
  #   assert_redirected_to @@movement
  #   @@movement.reload
  #   assert_equal 'New @movement', @@movement.concept
  #   assert_equal '28-06-2018', @@movement.date
  #   assert_equal '60', @@movement.amount
  #   assert_equal 'New description', @@movement.description
  # end
  #
  # test 'update @movement should not work as admin user with incorrect data' do
  #   log_in_as(@admin)
  #   get edit_transaction_path(@@movement)
  #   post transactions_path, params: { @movement: { concept: '', date: '', amount: '', description: ''}}
  #   assert_select 'div.alert', 'The form contains 4 errors.'
  # end
  #
  # test 'destroy @movement should work properly as admin user' do
  #   log_in_as(@admin)
  #   get transaction_path(@@movement)
  #   assert_template 'movements/show'
  #   assert_difference 'Movement.count', -1 do
  #     delete transaction_path(@@movement)
  #   end
  #   assert_redirected_to transactions_path
  # end

end

require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @transaction = transactions(:ingreso1)

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

  test 'should get correct transaction' do
    get transaction_path(@transaction)
    assert_template 'transactions/show'
    assert_select 'h1', "Datos del movimiento bancario #{@transaction.concept}"
  end

  # TODO Averiguar por qué los tests con usuarios no están funcionando

  # test 'create as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get new_transaction_path
  #   post transactions_path, params: { transaction: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   assert_permissions
  # end
  #
  # test 'edit as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get edit_transaction_path(@transaction)
  #   assert_template 'transactions/edit'
  #   post transactions_path, params: { transaction: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   assert_permissions
  # end
  #
  # test 'delete as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get transaction_path(@transaction)
  #   assert_no_difference 'Transaction.count' do
  #     delete transaction_path(@transaction)
  #   end
  #   assert_permissions
  # end
  #
  # test 'create transaction should work properly as admin user' do
  #   log_in_as(@admin)
  #   get new_transaction_path
  #   assert_difference 'Transaction.count', 1 do
  #     post transactions_path, params: { transaction: { concept: @concept, date: @date, amount: '50', description: @description}}
  #   end
  #   follow_redirect!
  #   assert_template 'transactions/show'
  #   assert_not flash.empty?
  # end
  #
  # test 'update transaction should work properly as admin user with correct data' do
  #   log_in_as(@admin)
  #   get edit_transaction_path(@transaction)
  #   binding.pry
  #   put transactions_path, params: { transaction: { concept: 'New transaction', date: '28-06-2018', amount: '60', description: 'New description'}}
  #   assert_not flash.empty?
  #   assert_redirected_to @transaction
  #   @transaction.reload
  #   assert_equal 'New transaction', @transaction.concept
  #   assert_equal '28-06-2018', @transaction.date
  #   assert_equal '60', @transaction.amount
  #   assert_equal 'New description', @transaction.description
  # end
  #
  # test 'update transaction should not work as admin user with incorrect data' do
  #   log_in_as(@admin)
  #   get edit_transaction_path(@transaction)
  #   post transactions_path, params: { transaction: { concept: '', date: '', amount: '', description: ''}}
  #   assert_select 'div.alert', 'The form contains 4 errors.'
  # end
  #
  # test 'destroy transaction should work properly as admin user' do
  #   log_in_as(@admin)
  #   get transaction_path(@transaction)
  #   assert_template 'transactions/show'
  #   assert_difference 'Transaction.count', -1 do
  #     delete transaction_path(@transaction)
  #   end
  #   assert_redirected_to transactions_path
  # end

end

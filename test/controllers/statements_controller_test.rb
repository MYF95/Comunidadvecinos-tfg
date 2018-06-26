require 'test_helper'

class StatementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @statement = statements(:junio)

    @name = 'Extracto junio 2018'
    @date = '01-06-2018'
  end

  # FUNCTIONS

  def assert_permissions
    follow_redirect!
    assert_equal flash[:danger], 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
  end

  # TESTS

  test 'should get new' do
    get new_statement_path
    assert_response :success
  end

  test 'should get index' do
    get statements_path
    assert_response :success
  end

  test 'should get correct statement' do
    get statement_path(@statement)
    assert_template 'statements/show'
    assert_select 'p', "Nombre del extracto: #{@statement.name}"
  end

  test 'create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_statement_path
    post statements_path, params: { statement: { name: @name, date: @date}}
    assert_permissions
  end

  test 'edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_statement_path(@statement)
    assert_template 'statements/edit'
    post statements_path, params: { statement: { name: @name, date: @date}}
    assert_permissions
  end

  test 'delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get statement_path(@statement)
    assert_no_difference 'Statement.count' do
      delete statement_path(@statement)
    end
    assert_permissions
  end

  test 'create statement should work properly as admin user' do
    log_in_as(@admin)
    get new_statement_path
    assert_difference 'Statement.count', 1 do
      post statements_path, params: { statement: { name: @name, date: @date}}
    end
    follow_redirect!
    assert_template 'statements/show'
    assert_not flash.empty?
  end

  test 'update statement should work properly as admin user with correct data' do
    log_in_as(@admin)
    get edit_statement_path(@statement)
    patch statement_path(@statement), params: { statement: { name: 'Extracto julio 2018', date: '01-07-2018'}}
    assert_not flash.empty?
    assert_redirected_to @statement
    @statement.reload
    assert_equal 'Extracto julio 2018', @statement.name
    assert_equal '01-07-2018', @statement.date.strftime("%d-%m-%Y")
  end

  test 'update statement should not work as admin user with incorrect data' do
    log_in_as(@admin)
    get edit_statement_path(@statement)
    patch statement_path(@statement), params: { statement: { name: '', date: ''}}
    assert_select 'div.alert', 'El formulario contiene algunos errores.'
  end

  test 'destroy statement should work properly as admin user' do
    log_in_as(@admin)
    get statement_path(@statement)
    assert_template 'statements/show'
    assert_difference 'Statement.count', -1 do
      delete statement_path(@statement)
    end
    assert_redirected_to statements_path
  end

  # TODO test de importar extracto bancario

  # test 'import statement' do
  # end
end

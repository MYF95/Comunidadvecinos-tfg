require 'test_helper'

class StatementsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @statement = statements(:junio)

    @name = 'Extracto junio 2018'
    @date = '01-06-2018'
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

  test 'Statements - should get index' do
    log_in_as(@user)
    get statements_path
    assert_response :success
  end

  test 'Statements - should get show' do
    log_in_as(@user)
    get statement_path(@statement)
    assert_template 'statements/show'
    assert_select 'p', "Nombre"
  end

  test 'Statements - create as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get new_statement_path
    post statements_path, params: { statement: { name: @name, date: @date}}
    assert_permissions
  end

  test 'Statements - edit as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get edit_statement_path(@statement)
    assert_template 'statements/edit'
    post statements_path, params: { statement: { name: @name, date: @date}}
    assert_permissions
  end

  test 'Statements - delete as non-admin user should redirect to homepage with message' do
    log_in_as(@user)
    get statement_path(@statement)
    assert_no_difference 'Statement.count' do
      delete statement_path(@statement)
    end
    assert_permissions
  end

  test 'Statements - should get new as admin' do
    log_in_as(@user)
    get new_statement_path
    assert_response :success
  end

  # test 'Statements - should get edit as admin' do
  #
  # end
  #
  # test 'Statements - should get bucket as admin' do
  #
  # end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, edit, update, destroy, bucket
  #
  # permissions: index, show
  #
  # actions: create, update, destroy

  # test 'Statements - import statement should work with correct data as admin' do
  #
  # end
  #
  # test 'Statements - import statement without day should put todays date as default' do
  #
  # end
  #
  # test 'Statements - import statement without attachment should not work' do
  #
  # end

  # test 'create statement should work properly as admin user' do
  #   log_in_as(@admin)
  #   get new_statement_path
  #   assert_difference 'Statement.count', 1 do
  #     post statements_path, params: { statement: { name: @name, date: @date}}
  #   end
  #   follow_redirect!
  #   assert_template 'statements/show'
  #   assert_not flash.empty?
  # end

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
    assert_select 'div.form-alert', 'El formulario contiene algunos errores.'
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
end

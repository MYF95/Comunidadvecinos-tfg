require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup

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

  # test 'Users - should get index' do
  #
  # end
  #
  # test 'Users - should get show' do
  #
  # end
  #
  # test 'Users - new as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users - user_list as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users - should get new as admin' do
  #
  # end
  #
  # test 'Users - should get user_list as admin' do
  #
  # end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, destroy, user_list
  #
  # permissions: index, show
  #
  # actions: create, destroy

  # test 'Users - create user as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users - create user should work with correct data as admin' do
  #
  # end
  #
  # test 'Users - create user should not work with incorrect data' do
  #
  # end
  #
  # test 'Users - destroy user as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users - destroy user should work as admin' do
  #
  # end
end

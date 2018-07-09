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

  # test 'Users Controller 001 - should get index' do
  #
  # end
  #
  # test 'Users Controller 002 - should get show' do
  #
  # end
  #
  # test 'Users Controller 003 - new as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users Controller 004 - user_list as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users Controller 005 - should get new as admin' do
  #
  # end
  #
  # test 'Users Controller 006 - should get user_list as admin' do
  #
  # end

  ###########
  # ACTIONS #
  ###########

  # All controller actions: index, new, create, show, destroy, user_list, approve
  #
  # permissions: index, show
  #
  # actions: create, destroy, approve

  # test 'Users Controller 007 - create user as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users Controller 008 - create user should work with correct data as admin' do
  #
  # end
  #
  # test 'Users Controller 009 - create user should not work with incorrect data' do
  #
  # end
  #
  # test 'Users Controller 010 - destroy user as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users Controller 011 - destroy user should work as admin' do
  #
  # end
  #
  # test 'Users Controller 012 - approve as non-admin user should redirect to homepage with message' do
  #
  # end
  #
  # test 'Users Controller 013 - approve should work as admin' do
  #
  # end
end

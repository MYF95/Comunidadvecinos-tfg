require 'test_helper'

class ApartmentsControllerTest < ActionDispatch::IntegrationTest
  #TODO mostrar los tests de uno en uno

  def setup
    @admin = users(:admin)
    @user = users(:user)
    @apartment = apartments(:primero)
  end

  # FUNCTIONS

  def assert_permissions
    assert_redirected_to root_path
    assert_select 'div', 'Tu cuenta no tiene permisos para realizar esa acción. Por favor, contacta con el administrador para más información.'
  end

  # TESTS

  test 'should get new' do
    get new_apartment_path
    assert_response :success
  end

  test 'should get index' do
    get apartments_path
    assert_response :success
  end

  test 'should get correct apartment' do
    get apartment_path(@apartment)
    assert_template 'apartments/show'
    assert_select 'h1', "Estos son los datos de la vivienda #{full_name_apartment @apartment}"
  end

  # TODO Averiguar por qué los tests con usuarios no están funcionando
  # TODO test de pisos duplicados

  # test 'create as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get new_apartment_path
  #   post apartments_path, params: { apartment: { owner: "#{full_name(@user)}", floor: '1', letter: 'B', fee: '60'}}
  #   assert_permissions
  # end
  #
  # test 'edit as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get edit_apartment_path(@apartment)
  #   assert_template 'apartments/edit'
  #   post apartments_path, params: { apartment: { owner: full_name(@admin), floor: 1, letter: 'B', fee: 60 }}
  #   assert_permissions
  # end
  #
  # test 'delete as non-admin user should redirect to homepage with message' do
  #   log_in_as(@user)
  #   get apartment_path(@apartment)
  #   assert_no_difference 'Apartment.count' do
  #     delete apartment_path(@apartment)
  #   end
  #   assert_permissions
  # end
  #
  # test 'create apartment should work properly as admin user' do
  #   log_in_as(@admin)
  #   get new_apartment_path
  #   assert_difference 'Apartment.count', 1 do
  #     post apartments_path, params: { apartment: { owner: full_name(@admin), floor: 1, letter: 'B', fee: 60 }}
  #   end
  #   follow_redirect!
  #   assert_template 'apartments/show'
  #   assert_not flash.empty?
  # end
  #
  # test 'update apartment should work properly as admin user with correct data' do
  #   log_in_as(@admin)
  #   get edit_apartment_path(@apartment)
  #   binding.pry
  #   patch apartment_path(@apartment), params: { apartment: { owner: full_name(@admin), floor: 1, letter: 'B', fee: 60}, admin: @admin}
  #   assert_not flash.empty?
  #   assert_redirected_to @apartment
  #   @apartment.reload
  #   assert_equal full_name(@admin), @apartment.owner
  #   assert_equal 1, @apartment.floor
  #   assert_equal 'B', @apartment.letter
  #   assert_equal 60, @apartment.fee
  # end
  #
  # test 'update apartment should not work as admin user with incorrect data' do
  #   log_in_as(@admin)
  #   get edit_apartment_path(@apartment)
  #   patch apartment_path(@apartment), params: { apartment: { owner: '', floor: '', letter: '', fee: '' }}
  #   assert_select 'div.alert', 'The form contains 3 errors.'
  # end
  #
  # test 'destroy apartment should work properly as admin user' do
  #   log_in_as(@admin)
  #   get apartment_path(@apartment)
  #   assert_template 'apartments/show'
  #   assert_difference 'Apartment.count', -1 do
  #     delete apartment_path(@apartment)
  #   end
  #   assert_redirected_to apartments_path
  # end
  #
  # test 'create apartment should not work for duplicate floor and letter' do
  # end
end

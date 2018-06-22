require 'test_helper'

class PendingPaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pending_payments_index_url
    assert_response :success
  end

  test "should get new" do
    get pending_payments_new_url
    assert_response :success
  end

  test "should get show" do
    get pending_payments_show_url
    assert_response :success
  end

  test "should get edit" do
    get pending_payments_edit_url
    assert_response :success
  end

end

require 'test_helper'

class FbConnectionsControllerTest < ActionController::TestCase
  setup do
    @fb_connection = fb_connections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fb_connections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fb_connection" do
    assert_difference('FbConnection.count') do
      post :create, fb_connection: {  }
    end

    assert_redirected_to fb_connection_path(assigns(:fb_connection))
  end

  test "should show fb_connection" do
    get :show, id: @fb_connection
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fb_connection
    assert_response :success
  end

  test "should update fb_connection" do
    put :update, id: @fb_connection, fb_connection: {  }
    assert_redirected_to fb_connection_path(assigns(:fb_connection))
  end

  test "should destroy fb_connection" do
    assert_difference('FbConnection.count', -1) do
      delete :destroy, id: @fb_connection
    end

    assert_redirected_to fb_connections_path
  end
end

require 'test_helper'

class HelpInfosControllerTest < ActionController::TestCase
  setup do
    @help_info = help_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:help_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create help_info" do
    assert_difference('HelpInfo.count') do
      post :create, :help_info => @help_info.attributes
    end

    assert_redirected_to help_info_path(assigns(:help_info))
  end

  test "should show help_info" do
    get :show, :id => @help_info.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @help_info.to_param
    assert_response :success
  end

  test "should update help_info" do
    put :update, :id => @help_info.to_param, :help_info => @help_info.attributes
    assert_redirected_to help_info_path(assigns(:help_info))
  end

  test "should destroy help_info" do
    assert_difference('HelpInfo.count', -1) do
      delete :destroy, :id => @help_info.to_param
    end

    assert_redirected_to help_infos_path
  end
end

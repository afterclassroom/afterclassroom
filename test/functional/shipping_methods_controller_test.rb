require 'test_helper'

class ShippingMethodsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:shipping_methods)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_shipping_method
    assert_difference('ShippingMethod.count') do
      post :create, :shipping_method => { }
    end

    assert_redirected_to shipping_method_path(assigns(:shipping_method))
  end

  def test_should_show_shipping_method
    get :show, :id => shipping_methods(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => shipping_methods(:one).id
    assert_response :success
  end

  def test_should_update_shipping_method
    put :update, :id => shipping_methods(:one).id, :shipping_method => { }
    assert_redirected_to shipping_method_path(assigns(:shipping_method))
  end

  def test_should_destroy_shipping_method
    assert_difference('ShippingMethod.count', -1) do
      delete :destroy, :id => shipping_methods(:one).id
    end

    assert_redirected_to shipping_methods_path
  end
end

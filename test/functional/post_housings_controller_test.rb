require 'test_helper'

class PostHousingsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_housings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_housing
    assert_difference('PostHousing.count') do
      post :create, :post_housing => { }
    end

    assert_redirected_to post_housing_path(assigns(:post_housing))
  end

  def test_should_show_post_housing
    get :show, :id => post_housings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_housings(:one).id
    assert_response :success
  end

  def test_should_update_post_housing
    put :update, :id => post_housings(:one).id, :post_housing => { }
    assert_redirected_to post_housing_path(assigns(:post_housing))
  end

  def test_should_destroy_post_housing
    assert_difference('PostHousing.count', -1) do
      delete :destroy, :id => post_housings(:one).id
    end

    assert_redirected_to post_housings_path
  end
end

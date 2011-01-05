require 'test_helper'

class HousingCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:housing_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_housing_category
    assert_difference('HousingCategory.count') do
      post :create, :housing_category => { }
    end

    assert_redirected_to housing_category_path(assigns(:housing_category))
  end

  def test_should_show_housing_category
    get :show, :id => housing_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => housing_categories(:one).id
    assert_response :success
  end

  def test_should_update_housing_category
    put :update, :id => housing_categories(:one).id, :housing_category => { }
    assert_redirected_to housing_category_path(assigns(:housing_category))
  end

  def test_should_destroy_housing_category
    assert_difference('HousingCategory.count', -1) do
      delete :destroy, :id => housing_categories(:one).id
    end

    assert_redirected_to housing_categories_path
  end
end

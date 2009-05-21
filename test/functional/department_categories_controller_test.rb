require 'test_helper'

class DepartmentCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:department_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_department_category
    assert_difference('DepartmentCategory.count') do
      post :create, :department_category => { }
    end

    assert_redirected_to department_category_path(assigns(:department_category))
  end

  def test_should_show_department_category
    get :show, :id => department_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => department_categories(:one).id
    assert_response :success
  end

  def test_should_update_department_category
    put :update, :id => department_categories(:one).id, :department_category => { }
    assert_redirected_to department_category_path(assigns(:department_category))
  end

  def test_should_destroy_department_category
    assert_difference('DepartmentCategory.count', -1) do
      delete :destroy, :id => department_categories(:one).id
    end

    assert_redirected_to department_categories_path
  end
end

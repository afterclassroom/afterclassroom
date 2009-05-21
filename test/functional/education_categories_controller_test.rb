require 'test_helper'

class EducationCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:education_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_education_category
    assert_difference('EducationCategory.count') do
      post :create, :education_category => { }
    end

    assert_redirected_to education_category_path(assigns(:education_category))
  end

  def test_should_show_education_category
    get :show, :id => education_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => education_categories(:one).id
    assert_response :success
  end

  def test_should_update_education_category
    put :update, :id => education_categories(:one).id, :education_category => { }
    assert_redirected_to education_category_path(assigns(:education_category))
  end

  def test_should_destroy_education_category
    assert_difference('EducationCategory.count', -1) do
      delete :destroy, :id => education_categories(:one).id
    end

    assert_redirected_to education_categories_path
  end
end

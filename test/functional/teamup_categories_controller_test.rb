require 'test_helper'

class TeamupCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:teamup_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_teamup_category
    assert_difference('TeamupCategory.count') do
      post :create, :teamup_category => { }
    end

    assert_redirected_to teamup_category_path(assigns(:teamup_category))
  end

  def test_should_show_teamup_category
    get :show, :id => teamup_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => teamup_categories(:one).id
    assert_response :success
  end

  def test_should_update_teamup_category
    put :update, :id => teamup_categories(:one).id, :teamup_category => { }
    assert_redirected_to teamup_category_path(assigns(:teamup_category))
  end

  def test_should_destroy_teamup_category
    assert_difference('TeamupCategory.count', -1) do
      delete :destroy, :id => teamup_categories(:one).id
    end

    assert_redirected_to teamup_categories_path
  end
end

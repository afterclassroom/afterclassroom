require 'test_helper'

class PostCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_category
    assert_difference('PostCategory.count') do
      post :create, :post_category => { }
    end

    assert_redirected_to post_category_path(assigns(:post_category))
  end

  def test_should_show_post_category
    get :show, :id => post_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_categories(:one).id
    assert_response :success
  end

  def test_should_update_post_category
    put :update, :id => post_categories(:one).id, :post_category => { }
    assert_redirected_to post_category_path(assigns(:post_category))
  end

  def test_should_destroy_post_category
    assert_difference('PostCategory.count', -1) do
      delete :destroy, :id => post_categories(:one).id
    end

    assert_redirected_to post_categories_path
  end
end

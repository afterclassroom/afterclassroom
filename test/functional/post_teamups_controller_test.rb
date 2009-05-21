require 'test_helper'

class PostTeamupsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_teamups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_teamup
    assert_difference('PostTeamup.count') do
      post :create, :post_teamup => { }
    end

    assert_redirected_to post_teamup_path(assigns(:post_teamup))
  end

  def test_should_show_post_teamup
    get :show, :id => post_teamups(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_teamups(:one).id
    assert_response :success
  end

  def test_should_update_post_teamup
    put :update, :id => post_teamups(:one).id, :post_teamup => { }
    assert_redirected_to post_teamup_path(assigns(:post_teamup))
  end

  def test_should_destroy_post_teamup
    assert_difference('PostTeamup.count', -1) do
      delete :destroy, :id => post_teamups(:one).id
    end

    assert_redirected_to post_teamups_path
  end
end

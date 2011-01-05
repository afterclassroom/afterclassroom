require 'test_helper'

class PostAwarenessesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_awarenesses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_awareness
    assert_difference('PostAwareness.count') do
      post :create, :post_awareness => { }
    end

    assert_redirected_to post_awareness_path(assigns(:post_awareness))
  end

  def test_should_show_post_awareness
    get :show, :id => post_awarenesses(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_awarenesses(:one).id
    assert_response :success
  end

  def test_should_update_post_awareness
    put :update, :id => post_awarenesses(:one).id, :post_awareness => { }
    assert_redirected_to post_awareness_path(assigns(:post_awareness))
  end

  def test_should_destroy_post_awareness
    assert_difference('PostAwareness.count', -1) do
      delete :destroy, :id => post_awarenesses(:one).id
    end

    assert_redirected_to post_awarenesses_path
  end
end

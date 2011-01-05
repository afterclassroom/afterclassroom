require 'test_helper'

class PostTutorsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_tutors)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_tutor
    assert_difference('PostTutor.count') do
      post :create, :post_tutor => { }
    end

    assert_redirected_to post_tutor_path(assigns(:post_tutor))
  end

  def test_should_show_post_tutor
    get :show, :id => post_tutors(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_tutors(:one).id
    assert_response :success
  end

  def test_should_update_post_tutor
    put :update, :id => post_tutors(:one).id, :post_tutor => { }
    assert_redirected_to post_tutor_path(assigns(:post_tutor))
  end

  def test_should_destroy_post_tutor
    assert_difference('PostTutor.count', -1) do
      delete :destroy, :id => post_tutors(:one).id
    end

    assert_redirected_to post_tutors_path
  end
end

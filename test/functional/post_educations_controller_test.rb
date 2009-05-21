require 'test_helper'

class PostEducationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_educations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_education
    assert_difference('PostEducation.count') do
      post :create, :post_education => { }
    end

    assert_redirected_to post_education_path(assigns(:post_education))
  end

  def test_should_show_post_education
    get :show, :id => post_educations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_educations(:one).id
    assert_response :success
  end

  def test_should_update_post_education
    put :update, :id => post_educations(:one).id, :post_education => { }
    assert_redirected_to post_education_path(assigns(:post_education))
  end

  def test_should_destroy_post_education
    assert_difference('PostEducation.count', -1) do
      delete :destroy, :id => post_educations(:one).id
    end

    assert_redirected_to post_educations_path
  end
end

require 'test_helper'

class FunctionalExperiencesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:functional_experiences)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_functional_experience
    assert_difference('FunctionalExperience.count') do
      post :create, :functional_experience => { }
    end

    assert_redirected_to functional_experience_path(assigns(:functional_experience))
  end

  def test_should_show_functional_experience
    get :show, :id => functional_experiences(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => functional_experiences(:one).id
    assert_response :success
  end

  def test_should_update_functional_experience
    put :update, :id => functional_experiences(:one).id, :functional_experience => { }
    assert_redirected_to functional_experience_path(assigns(:functional_experience))
  end

  def test_should_destroy_functional_experience
    assert_difference('FunctionalExperience.count', -1) do
      delete :destroy, :id => functional_experiences(:one).id
    end

    assert_redirected_to functional_experiences_path
  end
end

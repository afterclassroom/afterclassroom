require 'test_helper'

class JobTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:job_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_job_type
    assert_difference('JobType.count') do
      post :create, :job_type => { }
    end

    assert_redirected_to job_type_path(assigns(:job_type))
  end

  def test_should_show_job_type
    get :show, :id => job_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => job_types(:one).id
    assert_response :success
  end

  def test_should_update_job_type
    put :update, :id => job_types(:one).id, :job_type => { }
    assert_redirected_to job_type_path(assigns(:job_type))
  end

  def test_should_destroy_job_type
    assert_difference('JobType.count', -1) do
      delete :destroy, :id => job_types(:one).id
    end

    assert_redirected_to job_types_path
  end
end

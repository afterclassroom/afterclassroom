require 'test_helper'

class PostJobsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_jobs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_job
    assert_difference('PostJob.count') do
      post :create, :post_job => { }
    end

    assert_redirected_to post_job_path(assigns(:post_job))
  end

  def test_should_show_post_job
    get :show, :id => post_jobs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_jobs(:one).id
    assert_response :success
  end

  def test_should_update_post_job
    put :update, :id => post_jobs(:one).id, :post_job => { }
    assert_redirected_to post_job_path(assigns(:post_job))
  end

  def test_should_destroy_post_job
    assert_difference('PostJob.count', -1) do
      delete :destroy, :id => post_jobs(:one).id
    end

    assert_redirected_to post_jobs_path
  end
end

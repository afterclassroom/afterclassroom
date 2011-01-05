require 'test_helper'

class PostExamSchedulesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_exam_schedules)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_exam_schedule
    assert_difference('PostExamSchedule.count') do
      post :create, :post_exam_schedule => { }
    end

    assert_redirected_to post_exam_schedule_path(assigns(:post_exam_schedule))
  end

  def test_should_show_post_exam_schedule
    get :show, :id => post_exam_schedules(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_exam_schedules(:one).id
    assert_response :success
  end

  def test_should_update_post_exam_schedule
    put :update, :id => post_exam_schedules(:one).id, :post_exam_schedule => { }
    assert_redirected_to post_exam_schedule_path(assigns(:post_exam_schedule))
  end

  def test_should_destroy_post_exam_schedule
    assert_difference('PostExamSchedule.count', -1) do
      delete :destroy, :id => post_exam_schedules(:one).id
    end

    assert_redirected_to post_exam_schedules_path
  end
end

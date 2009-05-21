require 'test_helper'

class AwarenessIssuesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:awareness_issues)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_awareness_issue
    assert_difference('AwarenessIssue.count') do
      post :create, :awareness_issue => { }
    end

    assert_redirected_to awareness_issue_path(assigns(:awareness_issue))
  end

  def test_should_show_awareness_issue
    get :show, :id => awareness_issues(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => awareness_issues(:one).id
    assert_response :success
  end

  def test_should_update_awareness_issue
    put :update, :id => awareness_issues(:one).id, :awareness_issue => { }
    assert_redirected_to awareness_issue_path(assigns(:awareness_issue))
  end

  def test_should_destroy_awareness_issue
    assert_difference('AwarenessIssue.count', -1) do
      delete :destroy, :id => awareness_issues(:one).id
    end

    assert_redirected_to awareness_issues_path
  end
end

require 'test_helper'

class PostPartiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_parties)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_party
    assert_difference('PostParty.count') do
      post :create, :post_party => { }
    end

    assert_redirected_to post_party_path(assigns(:post_party))
  end

  def test_should_show_post_party
    get :show, :id => post_parties(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_parties(:one).id
    assert_response :success
  end

  def test_should_update_post_party
    put :update, :id => post_parties(:one).id, :post_party => { }
    assert_redirected_to post_party_path(assigns(:post_party))
  end

  def test_should_destroy_post_party
    assert_difference('PostParty.count', -1) do
      delete :destroy, :id => post_parties(:one).id
    end

    assert_redirected_to post_parties_path
  end
end

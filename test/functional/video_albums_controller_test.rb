require 'test_helper'

class VideoAlbumsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:video_albums)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_video_album
    assert_difference('VideoAlbum.count') do
      post :create, :video_album => { }
    end

    assert_redirected_to video_album_path(assigns(:video_album))
  end

  def test_should_show_video_album
    get :show, :id => video_albums(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => video_albums(:one).id
    assert_response :success
  end

  def test_should_update_video_album
    put :update, :id => video_albums(:one).id, :video_album => { }
    assert_redirected_to video_album_path(assigns(:video_album))
  end

  def test_should_destroy_video_album
    assert_difference('VideoAlbum.count', -1) do
      delete :destroy, :id => video_albums(:one).id
    end

    assert_redirected_to video_albums_path
  end
end

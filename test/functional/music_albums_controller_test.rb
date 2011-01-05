require 'test_helper'

class MusicAlbumsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:music_albums)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_music_album
    assert_difference('MusicAlbum.count') do
      post :create, :music_album => { }
    end

    assert_redirected_to music_album_path(assigns(:music_album))
  end

  def test_should_show_music_album
    get :show, :id => music_albums(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => music_albums(:one).id
    assert_response :success
  end

  def test_should_update_music_album
    put :update, :id => music_albums(:one).id, :music_album => { }
    assert_redirected_to music_album_path(assigns(:music_album))
  end

  def test_should_destroy_music_album
    assert_difference('MusicAlbum.count', -1) do
      delete :destroy, :id => music_albums(:one).id
    end

    assert_redirected_to music_albums_path
  end
end

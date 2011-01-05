require 'test_helper'

class MusicsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:musics)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_music
    assert_difference('Music.count') do
      post :create, :music => { }
    end

    assert_redirected_to music_path(assigns(:music))
  end

  def test_should_show_music
    get :show, :id => musics(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => musics(:one).id
    assert_response :success
  end

  def test_should_update_music
    put :update, :id => musics(:one).id, :music => { }
    assert_redirected_to music_path(assigns(:music))
  end

  def test_should_destroy_music
    assert_difference('Music.count', -1) do
      delete :destroy, :id => musics(:one).id
    end

    assert_redirected_to musics_path
  end
end

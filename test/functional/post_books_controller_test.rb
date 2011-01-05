require 'test_helper'

class PostBooksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:post_books)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_post_book
    assert_difference('PostBook.count') do
      post :create, :post_book => { }
    end

    assert_redirected_to post_book_path(assigns(:post_book))
  end

  def test_should_show_post_book
    get :show, :id => post_books(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => post_books(:one).id
    assert_response :success
  end

  def test_should_update_post_book
    put :update, :id => post_books(:one).id, :post_book => { }
    assert_redirected_to post_book_path(assigns(:post_book))
  end

  def test_should_destroy_post_book
    assert_difference('PostBook.count', -1) do
      delete :destroy, :id => post_books(:one).id
    end

    assert_redirected_to post_books_path
  end
end

require 'test_helper'

class PartyTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:party_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_party_type
    assert_difference('PartyType.count') do
      post :create, :party_type => { }
    end

    assert_redirected_to party_type_path(assigns(:party_type))
  end

  def test_should_show_party_type
    get :show, :id => party_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => party_types(:one).id
    assert_response :success
  end

  def test_should_update_party_type
    put :update, :id => party_types(:one).id, :party_type => { }
    assert_redirected_to party_type_path(assigns(:party_type))
  end

  def test_should_destroy_party_type
    assert_difference('PartyType.count', -1) do
      delete :destroy, :id => party_types(:one).id
    end

    assert_redirected_to party_types_path
  end
end

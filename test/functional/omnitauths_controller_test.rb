require 'test_helper'

class OmnitauthsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_create_invalid
    Omnitauth.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Omnitauth.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to omnitauths_url
  end

  def test_destroy
    omnitauth = Omnitauth.first
    delete :destroy, :id => omnitauth
    assert_redirected_to omnitauths_url
    assert !Omnitauth.exists?(omnitauth.id)
  end
end

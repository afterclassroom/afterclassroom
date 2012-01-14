require 'test_helper'

class OmnitauthTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Omnitauth.new.valid?
  end
end

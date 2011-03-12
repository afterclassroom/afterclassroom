require 'test_helper'

class QaSendMailTest < ActionMailer::TestCase
  test "refer_to_expert" do
    mail = QaSendMail.refer_to_expert
    assert_equal "Refer to expert", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

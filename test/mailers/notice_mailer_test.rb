require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "agree" do
    mail = NoticeMailer.agree
    assert_equal "Agree", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

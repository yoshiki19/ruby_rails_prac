require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "Userバリデーション空属性検証" do
    user = User.create(email: "", password: "", name: "")
    assert_empty user.email
    assert_empty user.password
    assert_equal 3, user.errors.count
  end
  test "Loginバリデーション空属性検証" do
    auth = Auth.new(email: "", password: "")
    # バリデーションを評価する
    auth.valid?
    assert_empty auth.email
    assert_empty auth.password
    assert_equal 2, auth.errors.count
  end
  test "User登録・更新・削除検証" do
    assert_difference "User.count", 1 do
      User.create(name: "山口ひろゆき", email: "hiro@testabc.co.jp",
        password: "password#test")
    end
    assert_difference "User.count", -1 do
      users(:one).destroy
    end
    # emailを変更（from、toで変更を指定）
    assert_changes "users(:two).email",
      from: "hanako@sample.com",to: "hana@example.com" do
        user = users(:two)
        user.update(email: "hana@example.com")
    end
  end
end

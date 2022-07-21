require 'test_helper'

class LogoutControlTest < ActionDispatch::IntegrationTest

  # 未ログイン状態でのログイン制御
  test "トップページの接続" do
    get root_url(locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "会議室一覧の接続" do
    get rooms_url(locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "会議室登録の接続" do
    get new_room_url(locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "会議室編集の接続" do
    get edit_room_url(rooms(:two), locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "会議室削除の接続" do
    delete room_url(rooms(:one), locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "予約登録の接続" do
    get new_room_entry_url(rooms(:one), locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "予約取り消しの接続" do
    delete entry_url(entries(:one), locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "ユーザー登録処理（サインアップ）" do
    get new_user_url(locale: "ja")
    assert_response :success
    post users_url(locale: "ja"),
      params: {user: {name: "sample_test",
        email: "sample@sample.com", password: "password"}}
    assert_redirected_to user_url(User.last, locale: "ja")
    assert_equal flash[:notice],
      I18n.t('message.register_complete', model: User.model_name.human)
  end
  test "ユーザー編集の接続" do
    get edit_user_url(users(:two), locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
  test "ユーザー削除の接続" do
    delete user_url(users(:three), locale: "ja")
    assert_redirected_to new_auths_url(locale: "ja")
  end
end

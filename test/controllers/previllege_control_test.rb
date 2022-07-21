require 'test_helper'

class PrevillegeControlTest < ActionDispatch::IntegrationTest
  setup do
    # ログイン処理（非特権ユーザー）
    post auths_url(locale: "ja"),
      params: {auth: { email: "hanako@sample.com", password: "hanahana222"}}
  end
  test "トップページの呼び出し" do
    get root_url(locale: "ja")
    assert_response :success
  end
  test "会議室一覧の呼び出し(index)" do
    get rooms_url(locale: "ja")
    assert_response :success
  end
  test "会議室登録の呼び出し(new-create)" do
    get new_room_url(locale: "ja")
    assert_redirected_to root_url(locale: "ja")
    post rooms_url(locale: "ja")
    assert_redirected_to root_url(locale: "ja")
  end
  test "会議室編集の呼び出し(edit-update)" do
    get edit_room_url(rooms(:two), locale: "ja")
    assert_redirected_to root_url(locale: "ja")
    patch room_url(rooms(:two), locale: "ja")
    assert_redirected_to root_url(locale: "ja")
  end
  test "会議室削除の呼び出し(destroy)" do
    delete room_url(rooms(:one), locale: "ja")
    assert_redirected_to root_url(locale: "ja")
  end
  test "予約登録処理(entry/new-confirm-create)" do
    get new_room_entry_url(rooms(:two), locale: "ja")
    assert_response :success
    post confirm_room_entries_url(locale: "ja"),
      params: {entry: {reserved_date: Time.now,
        usage_time: 1, people: 5, room_id: rooms(:two).id}}
    assert_response :success
    post room_entries_url(locale: "ja"),
      params: {entry: {reserved_date: Time.now,
        usage_time: 1, people: 5, room_id: rooms(:two).id}}
    assert_equal flash[:notice], "予約完了"
    assert_redirected_to room_url(rooms(:two), locale: "ja")
  end
  test "異なるユーザーの予約取り消し処理(entry/destroy)" do
    assert_raises ActiveRecord::RecordNotFound do
      delete entry_url(entries(:one), locale: "ja"), xhr: true
    end
  end
  test "同一ユーザーの予約取り消し処理(entry/destroy)" do
    user = User.find_by(email: "hanako@sample.com")
    entry = user.entries.first
    delete entry_url(entry, locale: "ja"), xhr: true
    assert_response :success
  end
end

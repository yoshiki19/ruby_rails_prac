require 'test_helper'

class LoginControlTest < ActionDispatch::IntegrationTest
  setup do
    # テスト用アップロード画像
    @room = rooms(:one)
    upload_file = Rack::Test::UploadedFile.new(Rails.root.join( "test/fixtures/files/room.jpg"))
    @room_images = [upload_file]
    # ログイン処理（特権ユーザー）
    post auths_url(locale: "ja"),
      params: {auth: {email: "taro@sample.com", password: "tarotaro123"}}
  end
  test "トップページの接続" do
    get root_url(locale: "ja")
    assert_response :success
  end
  test "会議室一覧の接続" do
    get rooms_url(locale: "ja")
    assert_response :success
  end
  test "会議室登録の接続" do
    get new_room_url(locale: "ja")
    assert_response :success
    post rooms_url(locale: "ja"),
      params: {room: { name: "テスト#99", place: "仙台", number: 15, images: @room_images}}
    assert_equal flash[:notice],
      I18n.t("message.register_complete", model: Room.model_name.human)
  end
  test "会議室編集の接続" do
    get edit_room_url(rooms(:two), locale: "ja")
    assert_response :success
    patch room_url(rooms(:two), locale: "ja"),
      params: {room: { name: "北海道#01", place: "札幌", number: 10, images: @room_images}}
    assert_equal flash[:notice],
      I18n.t("message.update_complete", model: Room.model_name.human)
  end
  test "会議室削除の接続" do
    delete room_url(rooms(:one), locale: "ja")
    assert_redirected_to rooms_url(locale: "ja")
    assert_equal flash[:notice],
      I18n.t("message.delete_complete", model: Room.model_name.human)
  end
  test "予約登録の接続" do
    get new_room_entry_url(rooms(:one), locale: "ja")
    assert_response :success
  end
  test "予約取り消しの接続（ログインユーザーと同じ）" do
    # ログインユーザーと等しい予約取り消し
    entry = entries(:one)
    room = entry.room
    delete entry_url(entry, locale: "ja"), xhr: true
    assert_response :success
    # 削除後の予約一覧画面確認（ヘッダー行1つ予約行が2つある）
    get room_url(room, locale: "ja")
    assert_select "tr", 3
  end
  test "予約取り消しの接続（ログインユーザーと異なる）" do
    # ログインユーザーと等しい予約取り消し
    entry = entries(:two)
    room = entry.room
    # ログインユーザーと異なる場合、多少リソースなしの例外エラーになる
    assert_raises ActiveRecord::RecordNotFound do
      delete entry_url(entry, locale: "ja"), xhr: true
    end
    # 削除後の予約一覧画面確認（ヘッダー行1つ予約行が3つある）
    get room_url(room, locale: "ja")
    assert_select "tr", 4
  end
end

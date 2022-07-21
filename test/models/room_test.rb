require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  setup do
    @room = rooms(:one)
    upload_file = Rack::Test::UploadedFile.new(
      Rails.root.join("test/fixtures/files/room.jpg"))
    @room_images = [upload_file]
  end
  test "Roomバリデーション空属性検証" do
    room = Room.create(name: "", place: "", number: "", images: [])
    assert_equal 7, room.errors.count
  end
  test "Roomバリデーション仕様検証" do
    room = Room.create(name: "会議室", place: "未定", number: 4, images: [])
    assert_equal I18n.t("message.incorrect_name"),
      room.errors.messages[:name][0]
    assert_equal I18n.t("message.incorrect_number"),
      room.errors.messages[:number][1]
    assert_equal 5, room.errors.count
  end
  test "Room登録・更新・削除検証" do
    assert_difference "Room.count", 1 do
      Room.create(name: "テスト会議室#88",
        place: "東京", number: 20, images: @room_images)
    end
    assert_difference "rooms(:room_1).number", 10 do
      rooms(:room_1).update(number: 20)
    end
    assert_difference "Room.count", -1 do
      rooms(:room_2).destroy
    end
  end
  test "Room（会議室）・Entry（予約）の親子間削除検証" do
    @room_test = rooms(:room_5)
    @user_test = users(:one)
    # 予約エントリを3件追加する
    assert_difference "Entry.count", 3 do
      3.times do |i|
        @room_test.entries.create(
          reserved_date: Time.now, usage_time: 1, people: 5, user_id: @user_test.id)
      end
    end
    # Roomを削除した時子の予約エントリ3件を同時に削除する
    assert_difference "Room.count", -1 do
      assert_difference "Entry.count", -3 do
        rooms(:room_5).destroy
      end
    end
  end
end

require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  test "Entryバリデーション空属性検証" do
    entry = Entry.create(room: rooms(:two), user: users(:one))
    assert_nil entry.reserved_date
    assert_equal 3, entry.errors.count
  end
  test "Entry登録・削除検証" do
    assert_difference "Entry.count", 1 do
      Entry.create(reserved_date: Time.now,
         usage_time: 1, people: 5, room: rooms(:two), user: users(:one))
    end
    assert_difference "Entry.count", -1 do
      entries(:one).destroy
    end
  end
end

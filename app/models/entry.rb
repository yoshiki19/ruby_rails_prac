class Entry < ApplicationRecord
  # Roomモデルが親の関係
  belongs_to :room
  belongs_to :user

  # 基準日の前後７日間の予約データを取得するスコープ
  scope :least_entries,->(base_date) {
    where("reserved_date >= ? and reserved_date <= ?",
       base_date.to_date - 7.days, base_date.to_date + 7.days )
  }

  validates :reserved_date, :usage_time, :people, presence: true

end

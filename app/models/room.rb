class Room < ApplicationRecord
  # Entryモデルと1対多の関係
  has_many :entries, dependent: :destroy
  # 複数画像の設定
  has_many_attached :images

  # 空白削除のコールバック
  before_validation :space_edit

  validates :name, :place, :number, :images, presence: true
  validates :name, length: {maximum: 30}
  validates :place, inclusion: { in: [ '東京', '大阪', '福岡', '札幌', '仙台', '名古屋', '金沢' ] }
  validates :number, numericality: { greater_than: 4, less_than: 31 }
  # validates :name, format: { with: /\A.+#\d{2}\z/ }

  validate :name_format
  validate :check_x5

  private

  def name_format
    name_pattern = /\A.+#\d{2}\z/
    # unless name_pattern.match(self.name)
    unless name_pattern.match(name)
      errors.add(:name, I18n.t("message.incorrect_name"))
    end
  end
  def check_x5
    if (self.number.to_i % 5) != 0
      errors.add(:number, I18n.t("message.incorrect_number"))
    end
  end

  # 空白削除編集メソッド
  def space_edit
    self.name = self.name.strip.gsub(/ +/, "_")
  end

end

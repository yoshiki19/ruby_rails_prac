class NoticeMailer < ApplicationMailer
  def agreed(entry, url)
    @content = "#{entry.room.name}を#{entry.reserved_date}に#{entry.usage_time}時間予約完了しました。"
    @host = url
    mail to: entry.user.email
  end
end

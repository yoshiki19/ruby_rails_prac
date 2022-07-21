class EntriesController < ApplicationController
  before_action :set_entry, only: :destroy
  before_action :set_entry_params, only: [:confirm, :confirm_back, :create]

  def index
    @entries = Entry.all
  end

  def new
    @entry = current_user.entries.new(room_id: params[:room_id])
  end

  def confirm
    if @entry.invalid?
      render :new
    end
  end

  def confirm_back
    render :new
  end

  def create
    if @entry.save
      NoticeMailer.agreed(@entry, rooms_url).deliver_now
      redirect_to @entry.room,
        notice:  t('message.complete', model: @entry.model_name.human)
    else
      render :new
    end
  end

  def destroy
    # 予約のユーザーがログインユーザーと異なる時拒否する
    if current_user == @entry.user
      @entry.destroy
      respond_to do |format|
        # Ajaxのリクエストに対して成功のみを知らせる
        format.js { head :no_content }
      end
    else
      redirect_to root_path
    end
  end

  private

  def set_entry_params
    @entry = current_user.entries.new(entry_params)
  end

  def set_entry
    @entry = current_user.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:reserved_date, :usage_time,
      :room_id, :people, :user_id)
  end
end

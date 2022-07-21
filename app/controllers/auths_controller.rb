class AuthsController < ApplicationController
  skip_before_action :logged_in, only: [:new, :create]

  # ログインだけユーザ専用レイアウトを使用する
  layout "users", only: [:new, :create]

  def new
    # フォームオブジェクトAuthのインスタンス化
    @auth = Auth.new
  end

  def create
    # ログイン情報でインスタンス化しバリデーション評価を行う
    @auth =Auth.new(auth_params)
    if @auth.valid?
      user = User.find_by(email: params[:auth][:email])
      if user && BCrypt::Password.new(user.password) == params[:auth][:password]
        # ログイン情報と一致する時ユーザーidをセッションへ保存
        session[:user_id] = user.id
        redirect_to root_path
      else
        # 該当ユーザーなしの時ログインへ
        redirect_to new_auths_path
      end
    else
      # バリデーションエラーの時入力画面再表示
      render :new
    end
  end

  def destroy
    # セッション情報の初期化
    reset_session
    redirect_to new_auths_path
  end

  private
  def auth_params
    params.require(:auth).permit(:email,:password)
  end

end

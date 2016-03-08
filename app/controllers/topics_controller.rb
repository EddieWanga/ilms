class TopicsController < ApplicationController
  before_action :authenticate_user!, only: [:welcome, :verify_account, :user_profile]
  before_action :is_login?, only: [:get_account, :send_account]
  
  def welcome
    @topic = Topic.new
  end
  
  def verify_account
    @topic = Topic.new(topic_params)
    user = User.find_by(confirm_code: @topic.confirm_code)
    if user != nil
      user.update(role: 1)
      redirect_to root_path, notice: "帳號認證成功！"
    else
      flash[:alert] = "請檢查您的認證碼是否輸入正確？"
      render :welcome
    end
  end

  def get_account
    @topic = Topic.new
  end
   
  def send_account
    @topic = Topic.new(topic_params)
    email = @topic.confirm_code
    user = User.find_by(email: email)
    if user != nil
      if user.role != 2
        redirect_to get_account_path, alert: "此帳號已驗證！"
      else
        password = Dictionary.find_by(confirm_code: user.confirm_code).password
        UserMailer.notify_confirm(user, password, root_url).deliver_later!  
        redirect_to get_account_path, notice: "Hi, #{user.name} 請到電子信箱取得密碼和驗證碼！"
      end
    else
      flash[:alert] = "請檢查輸入的email是否正確"
      render :get_account
    end
  end
  
  def user_profile
  end
private

  def topic_params
    params.require(:topic).permit(:confirm_code)
  end

  def is_login?
    if current_user
      redirect_to root_path
    end
  end
end

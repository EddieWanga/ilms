class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:get_account, :send_account]
  before_action :is_confirmed_user?, only: [:welcome, :verify_account]
  before_action :is_admin?, only: [:user_management]
  before_action :is_login?, only: [:get_account, :send_account]
  
  def welcome
    @topic = Topic.new
  end
  
  def verify_account
    @topic = Topic.new(topic_params)
    user = User.find_by(confirm_code: @topic.confirm_code)
    if user == current_user
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

  def user_management
    students = User.where(role: 1)
    @teachers = User.where(role: 0)
    @pylang_students = students.where(district: "PyLang")
    @clang_students = students.where(district: "CLang")
    @double_class_students = students.where(district: nil)
    @unconfirmed_users = User.where(role: 2)
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

  def is_confirmed_user?
    if current_user.role != 2
      redirect_to root_path, alert: "您的帳號已經驗證過了"
    end
  end

  def is_admin?
    if current_user.role != 0
      redirect_to root_path
    end
  end
end

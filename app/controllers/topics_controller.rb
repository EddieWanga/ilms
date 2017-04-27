class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [:get_account, :send_account, :help]
  before_action :is_confirmed_user?, only: [:welcome, :verify_account]
  before_action :is_admin?, only: [:user_management, :new_users, :create_users, :destroy_user, :edit_user, :update_user]
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


    if params[:area] == "2"#show all students
      students = User.where(role:1)
      @unconfirmed_users = User.where(role: 2)
   
   
    else
      students = User.where(role: 1, area: params[:area])
      @unconfirmed_users = User.where(role: 2, area: params[:area])
    end

    @teachers = User.where(role: 0)
    @pylang_students = students.where(district: ["PyLang", nil, ""])
    @clang_students = students.where(district: ["CLang", nil, ""])
    
    
    #幫沒有地區的帳號分地區
    no_area_students = User.where(area:nil)
    no_area_students.each do |s|
      if s.id >= 1000 && s.id < 2000
        s.update(:area => 0)
      elsif s.id >= 2000 && s.id < 3000
        s.update(:area => 1)
      end 
    end
  

  end
  
  def new_users
    @topic = Topic.new
  end 
   
  def create_users
    @topic = Topic.new(topic_params)
    user_list = @topic.confirm_code.split(/[\r\n]+/)
    
    success_count = 0
    error_list = Array.new
    user_list.each do |user|
      if datasheet_parser(user, 2)
        success_count = success_count + 1
      else
  	    profile = user.split(",")
	    id = profile[0]
	    error_list.push(id)
      end
    end

    if error_list.empty?
      redirect_to show_users_path(2), notice: "新增了 #{success_count} 個學員"
    else
      redirect_to show_users_path(2), alert: "以下學員新增失敗（學員編號已存在或編號不合法）：#{error_list}"
      end
  end

  def destroy_user
    @user = User.find(params[:id])
    name = @user.name
    @user.destroy
    redirect_to show_users_path(2), alert: "刪除了 #{name} 學員"
  end

  def edit_user
    @user = User.find(params[:id])
    @user_new = User.new
    if @user.role == 0
      @role = '講師'
    elsif @user.role == 1
      @role = '學員'
    else 
      @role = '未認證'
    end

    if @user.area == 0
      @area = '北區'
    elsif @user.area = 1
      @area = '竹區'
    else
      @area = '未選擇'
    end
  end

  def update_user
    
    #if student has no district
    if user_params[:role] == "學員" &&( user_params[:district] == nil && user_params[:district] == "")
      redirect_to :back, alert: "學員請選擇班級！"
    else
      @user = User.find(params[:original_id])
      old_id = @user.id
      old_district = @user.district
      old_role = @user.role

      #update student data
      @user.update(:id => user_params[:id], :name => user_params[:name], :email => user_params[:email])
      if user_params[:role] == "講師"
     	 role = 0
      elsif user_params[:role] == "學員"
      	 role = 1
      elsif user_params[:role] == "未認證"
        role = 2
      else
        role = @user.role
      end
      @user.update(:role => role)
      if user_params[:district] != ""
        @user.update(:district => user_params[:district])
      end

      if user_params[:area] == '北區'
        @user.update(:area => 0)
      elsif user_params[:area] == '竹區'
        @user.update(:area => 1)
      end 
      #if teachers dont want district then uncomment
      #if @user.role == 0
   # 	@user.update(:district => "")
   #   end
    
      #update UserAttendance relationship if id altered
      if @user.id != old_id
        if UserAttendance.where(:user_id => old_id).exists?
          update_user_attendance = UserAttendance.where(:user_id => old_id)
          update_user_attendance.each do |user_attendance|
            user_attendance.update(:user_id => user_params[:id])
          end
        end
        if Answer.where(:author => old_id).exists?
          update_user_answer = Answer.where(:user_id => old_id)
          update_user_answer.each do |user_answer|
            user_answer.update(:user_id => user_params[:id])
          end
        end
      end
  
      #initialize userAttendance relationship when district is altered or a teacher has become a student. old data preserved but wont show on the web page.
      if @user.district != old_district || ( old_role == 0 && @user.role == 1)
        ini_attendance = Attendance.where(:district => @user.district)
        ini_attendance.each do |attendance|
          UserAttendance.create(:user => @user, :attendance => attendance, :attendance_date => attendance.date, :description => 0)
        end
      end
      redirect_to show_users_path(2), notice: "資料更新成功！"
    end
  end

  def help
  end

private

  def topic_params
    params.require(:topic).permit(:confirm_code)
  end

  def user_params
    params.require(:user).permit(:id, :name, :email, :role, :district, :area)
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
  
  def datasheet_parser(str, role) 
    begin
      profile = str.split(",")
      id = profile[0].to_i
      if User.exists?(:id => id)
	return false
      elsif id == 0 || id == ""
	return false
      end
      name = profile[1]
      email = profile[2]
      if email == nil
        email = "#{id}@gmail.com"
      end
      district = profile[3]
      area = sort_area(id)
      password = SecureRandom.hex.first(8)
      confirm_code = SecureRandom.base64(60)
      u = User.create(
        id: id,
      	email: email, 
        name: name, 
        role: role, 
        password: password, 
        confirm_code: confirm_code,
        district: district,
        area: area 
      ) 
      u = User.where(:id => id).take
      Dictionary.create(confirm_code: confirm_code, password: password)
      return true
    rescue
      return false
    end
  end

  def sort_area(id)
    if id >= 1000 && id < 2000
      return 0
    elsif id >=2000 && id < 3000
      return  1
    else
      return 2
    end
  end
end

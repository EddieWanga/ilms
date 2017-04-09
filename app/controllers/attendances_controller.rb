require "google_drive"
require "mysql2"

class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :is_confirmed_user?
  before_action :is_admin?, except: [:leave_request, :send_leave_request, :my_attendance]
  before_action :is_login?
  

  def index
  end

  def my_attendance
    @student = current_user
    @attendance_list = Attendance.where(:district => @student.district)
  end 

  def attendance_list
    students = User.where(role: 1)
    #@teachers = User.where(role: 0)
    pylang_students = students.where(district: ["PyLang", nil])
    clang_students = students.where(district: ["CLang", nil])
    #@unconfirmed_users = User.where(role: 2)
    
    #uncomment the following lines to defferentiate pylang and clang students
    if params[:district] == "PyLang"
      @students = pylang_students
    else
      @students = clang_students
    end
    
    #comment this line when the lines above are uncommented
    #@students = @unconfirmed_users
    
    #params for scanning id
    @district = params[:district] 
    @attendance_id = params[:attendance_id]

    @date = Attendance.where(:id => params[:attendance_id]).take.date
    @attendance = Attendance.where(:district => @district).where(:date => @date).first_or_create
    
    @scan = User.new
  end

  def scan_id
    if (not User.exists?(user_params)) || (User.where(user_params).take.id == nil)
      redirect_to attendance_list_path(params[:district], params[:attendance_id]), alert: "沒有這個學員吧..."
    else
      @date = Attendance.where(:id => params[:attendance_id]).take.date
      #update student.attendance.description to "ontime"
      student = User.where(user_params).take   
      @attendance = student.attendances.where(:district => params[:district]).where(:date => @date).take
      detail = UserAttendance.where(:user => student, :attendance => @attendance).take
      detail.update(:description => 1, :arrive_at => Time.new)
    
      redirect_to attendance_list_path(params[:district], params[:attendance_id]), notice: "報到成功！"
    end
  end
  
  def edit_description
    attendance = Attendance.where(:id => params[:attendance_id]).take
    date = attendance.date
    district = params[:district] 

    #one student only have one attendace on one day
    #there are four attendances owning the same date, each having different description number
    #description: ontime, late, absent, call_sick
    student = User.where(:id => params[:student_id]).take
    if not UserAttendance.where(:user_id => params[:student_id], :attendance => attendance).exists?   
      #create: default attendance.description = 0
      UserAttendance.create(:user => student, :attendance => attendance, :attendance_date => date, :description => 0) 
    end

    #when description is clicked, delete the old user.attendance and create a new one, whose description = old_description.next
    detail = UserAttendance.where(:user => student, :attendance => attendance).take
    description = detail.description
    detail.update(:description => (description + 1) % 5)
    if detail.description == 1 || detail.description == 2
      detail.update(:arrive_at => Time.new)
   end

    #redirect_to attendance_list_path(params[:district], params[:attendance_id])
  redirect_to attendance_list_path
  end

  def history
    @district = params[:district]
    @attendance_record = Attendance.where(:district => @district)
    @attendance_today = Attendance.new
  end

  def new_date
    if Attendance.where(:district => params[:district]).where(attendance_params).exists?
      redirect_to all_history_path(params[:district]), alert: "已經有這天的紀錄了喔!"
    elsif attendance_params[:date] == ""
      redirect_to all_history_path(params[:district]), alert: "你沒輸入日期喔！"
    else
      attendance = Attendance.create(attendance_params)
      attendance.update(:district => params[:district])

      #initialize all description on this date to 0
      student_list = User.where(:district => params[:district]).where(role: 1) 
      student_list.each do |student|
	UserAttendance.create(:user => student, :attendance => attendance, :attendance_date => attendance.date, :description => 0)
      end
      redirect_to all_history_path(params[:district]), notice: "新增成功！"
    end
  end

  def edit_date
    redirect_to all_history_path(params[:district])
  end
 
  def delete_date
    @attendance = Attendance.where(:id => params[:attendance_id]).where(:district => params[:district]).take
    @attendance.destroy
    redirect_to all_history_path(params[:district]), alert: "紀錄已刪除"
  end

  def upload_list
    #this function always create a new record on google sheet ( finding the first empty column), even if the record of the same date has been uploaded before
    session = GoogleDrive::Session.from_config("google_grade_and_attendance_config.json")
#    session = GoogleDrive.saved_sassion("google_attendance_config.json")
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'sprout', :database => 'sprout', :encoding => 'utf8')
    
    if params[:district] == "PyLang"
      ws = session.spreadsheet_by_key("13WdQwJch0sbfOhwLNWBqK3Q6-sBkrku4lYY27OHIMM4").worksheets[0]
    elsif params[:district] == "CLang"
      ws = session.spreadsheet_by_key("13WdQwJch0sbfOhwLNWBqK3Q6-sBkrku4lYY27OHIMM4").worksheets[1]
    end

    attendance = Attendance.where(:id => params[:attendance_id]).take
    date = attendance.date
   
    #find empty column to write new attendance record
    col = 0
    loop do
      col = col + 1
    break if ws[1, col] == ""
    end

    #write the attendance record, if student is not in the googlesheet, append
    ws[1,col] = date
    attendance.users.each do |student|
      detail = UserAttendance.where(:user => student, :attendance => attendance).take
      description = detail.description
      student_in_record = 0
      
      #if the student exists
      (2..200).each do |row|
        if ws[row,1] == (student.id).to_s
          ws[row,col] = description_to_chinese(description)
          student_in_record = 1
        end
      break if student_in_record == 1
      end
      #if the student !exists
      if student_in_record == 0
        (2..200).each do |row|
          if ws[row,1] == ""
            ws[row,1] = student.id
            ws[row,2] = student.name
            ws[row,col] = description_to_chinese(description)
            student_in_record = 1
          end
        break if student_in_record == 1
        end
      end
    end   
  ws.save
  redirect_to all_history_path(params[:district]), notice: "上傳成功! https://docs.google.com/spreadsheets/d/13WdQwJch0sbfOhwLNWBqK3Q6-sBkrku4lYY27OHIMM4"
  end

  #new = edit, create = update (shared method)
  def edit_note
    #params[:student_id] sometimes conflicts with current_user_id
    student_id = params[:student_id]
    attendance_id = params[:attendance_id]
    @student = User.where(:id => student_id).take
    @attendance = Attendance.where(:id => attendance_id).take
    date = @attendance.date

    @detail = UserAttendance.where(:user => @student, :attendance => params[:attendance_id]).take
    p @detail
    @new_detail = UserAttendance.new
  end
  
  def update_note
    student_id = params[:student_id]
    student = User.where(:id => student_id).take
    detail = UserAttendance.where(:user => student, :attendance => params[:attendance_id]).take
    detail.update(user_attendance_params)
    redirect_to attendance_list_path
  end

  def leave_request
    @request = Request.new
    @student = current_user
  end
  
  def send_leave_request
    student = current_user
    student.requests.create(:date => request_params[:date], :reason => request_params[:reason], :read => 0)
 #  if not Attendance.where(:date => request_params[:date]).exists?
  #   Attendance.create(:date
   redirect_to :root, notice:"請假成功！"
  end
  
  def list_requests
    @request_list = Request.all
  end

  def read_request
    request = Request.where(:id => params[:request_id]).take
    if request.read == 1
      request.update(:read => 0)
    else
      request.update(:read => 1)
    end
    redirect_to :back
  end

  def delete_request
    request = Request.where(params[:request_id]).take
    request.destroy
    redirect_to :back
  end
 
private
  def user_params
    params.require(:user).permit(:id)
  end

  def attendance_params
    params.require(:attendance).permit(:district, :date)
  end
  
  def user_attendance_params
    params.require(:user_attendance).permit(:note)
  end
  
  def request_params
    params.require(:request).permit(:date, :reason)
  end

  def is_login?
    if !current_user
      redirect_to root_path
    end
  end

  def is_confirmed_user?
    if current_user.role == 2
      redirect_to root_path, alert: "你的帳號還未認證喔!"
    end
  end

  def is_admin?
    if current_user.role != 0
      redirect_to root_path, alert: "你不是講師喔..."
    end
  end

  def description_to_chinese(description)
    if description == 0
      return "未到"
    elsif description == 1
      return "準時"
    elsif description == 2
      return "遲到"
    elsif description == 3
      return "請假"
    else description == 4
      return "缺席"
    end
  end

end

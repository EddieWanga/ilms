require 'google_drive'
require 'mysql2'

class GradesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :is_confirmed_user?
  before_action :is_admin?
  before_action :is_login?

  def index
#    @students = User.where(role: 2)
    if district == "PyLang"
      @students = User.where(:role => 1).where(:district => "PyLang")
    elsif @district == "CLang"
      @students = User.where(:role => 1).where(:district => "CLang")
    end
  end

  def show_grades
    @district = params[:district]
    
#    @students = User.where(role: 2)
#comment the above and uncomment the followings when deploying
    if @district == "PyLang"
      @students = User.where(:role => 1).where(:district => "PyLang")
    elsif @district == "CLang"
      @students = User.where(:role => 1).where(:district => "CLang")
    end

    @homework_list = Homework.where(:district => @district)
  end

  def upload_to_google
    #this upload function will rewrite the whole sheet
    #however it wont erase the student who was in the record but now is not
    session = GoogleDrive.saved_session("google_grade_and_attendance_config.json")
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => 'sprout', :database => 'sprout', :encoding => 'utf8')

    if params[:district] == "PyLang"
      ws = session.spreadsheet_by_key("13WdQwJch0sbfOhwLNWBqK3Q6-sBkrku4lYY27OHIMM4").worksheets[2]
    elsif params[:district] == "CLang"
      ws = session.spreadsheet_by_key("13WdQwJch0sbfOhwLNWBqK3Q6-sBkrku4lYY27OHIMM4").worksheets[3]
    end
    
#    @students = User.where(role: 2)
#comment the above and uncomment the followings when deploying
    if params[:district] == "PyLang"
      @students = User.where(:role => 1).where(:district => "PyLang")
    elsif params[:district] == "CLang"
      @students = User.where(:role => 1).where(:district => "CLang")
    end

    #write hw titles
    @homework_list = Homework.where(:district => params[:district])
    col = 3
    @homework_list.each do |homework|
      ws[1,col] = "hw#{col-2}" #ws[] = homework.title would be better
      col = col + 1
    end

    #write grades data
    row = 2
    @students.each do |student|
      ws[row,1] = student.id
      ws[row,2] = student.name
      col = 3
      @homework_list.each do |hw|
	@answer = hw.answers.where(:user_id => student.id).take
	if @answer != nil
	  ws[row,col] = @answer.point
        else
	  ws[row,col] = "未繳交"
        end
	col = col + 1
      end
      row = row + 1
    end
    ws.save
    redirect_to show_grades_path(params[:district]), notice: "上傳成功！ 表單網址：https://docs.google.com/spreadsheets/d/13WdQwJch0sbfOhwLNWBqK3Q6-sBkrku4lYY27OHIMM4/"
  end

private
  def is_login?
    if !current_user
      redirect_to root_path
    end
  end

  def is_confirmed_user?
    if current_user.role == 2
      redirect_to root_path, alert: "你的帳號還未認證喔！"
    end
  end

  def is_admin?
    if current_user.role != 0
      redirect_to root_path, alert: "你不是講師喔..."
    end
  end

end

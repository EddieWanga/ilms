class HomeworksController < ApplicationController
  before_action :authenticate_user!
  before_action :is_valid_user? 
  before_action :is_admin?, except: [:show, :index]
  
  def index
    @homeworks = Homework.all
    @total_student_counts = User.where(role: 1).size
  end

  def new
    @homework = Homework.new
  end

  def create
    @homework = Homework.create(homework_params)
    if @homework.save
      users = User.where(role: 1)
      users.each do |user|
        UserMailer.notify_new_homework(user, @homework, root_url, homework_path(@homework)).deliver_later! 	 	
      end
      redirect_to homework_path(@homework.id), notice: "成功新增一項作業"
    else
      flash[:alert] = "請不要什麼都不填QAQ"
      render :new
    end
  end
  
  def show
    @homework = Homework.find(params[:id])
    if current_user.role == 0 # If current user is member of administration group
      @answers = @homework.answers
      @submitted_students = @homework.members.to_a
      @students = User.where(role: 1).to_a
      @non_submitted_students = @students - @submitted_students
    elsif current_user.is_member_of?(@homework)
      @answer = @homework.answers.find_by(author: current_user)
      @review = @answer.review 
    else
      @answer = nil
    end
  end

  def edit
    @homework = Homework.find(params[:id])
  end
  
  def update
    @homework = Homework.find(params[:id])
    if @homework.update(homework_params)
      users = User.where(role: 1)
      users.each do |user|
        UserMailer.notify_new_homework(user, @homework, root_url, homework_path(@homework)).deliver_later! 	 	
      end
      redirect_to homework_path(@homework.id), notice: "作業更新成功！"
    else
      flash[:alert] = "是不是有什麼東西沒有填到？"
      render :edit
    end
  end
  
  def destroy
    @homework = Homework.find(params[:id])
    @homework.destroy
    redirect_to homeworks_path, alert: "作業已刪除"
  end

=begin
  def download
    send_file(File.join(Rails.root, "public", "uploads", "answer", "attachment", "1", "output.img"))
  end
=end

private
   
  def homework_params
    params.require(:homework).permit(:title, :description, :deadline)
  end
  
  def is_admin?
    if current_user.role != 0
      raise ActionController::RoutingError.new('Not Found') 
    end
  end 
end

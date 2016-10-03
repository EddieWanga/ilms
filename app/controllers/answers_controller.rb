require 'google/api_client'
require 'google_drive'

class AnswersController < ApplicationController
  before_action :authenticate_user!  
  before_action :is_valid_user? 
  before_action :find_homework, except: [:index]
   
  def index
    @answers = Answer.all
  end
  
  def new
    if !current_user.is_member_of?(@homework)
      @answer = @homework.answers.new
    else
      redirect_to homework_path(@homework), alert: "你早就交過作業了喔！"
    end
  end

  def create
    if !current_user.is_member_of?(@homework)
      @answer = @homework.answers.build(answer_params)
      @answer.author = current_user
      if @answer.save
        begin
          upload_to_google_drive(@answer)
        rescue
          flash[:alert] = "雖然你已經把作業交上去，不過上傳檔案失敗，再試一次好嗎 ~ QAQ"
          render :edit
        else
          current_user.join!(@homework) # submit the homework
          UserMailer.notify_submit(current_user, @answer, root_url).deliver_later! 	 	
          redirect_to homework_path(@homework), notice: "繳交作業成功！"
        end
      else
        flash[:alert] = "請檢查是否有哪些地方弄錯，如檔案超過50MB，或者沒有填Title？"
        render :new
      end
    else
      redirect_to homework_path(@homework), alert: "你已經繳交作業了喔：Ｄ"
    end
  end
  
  def edit
    if current_user.is_member_of?(@homework)
      @answer = @homework.answers.find(params[:id])
      if @answer.author != current_user
        redirect_to homework_path(@homework), alert: "不要偷改別人的作業 >///<"
      end
    else
      flash[:alert] = "你沒有交作業，是要更改什麼阿：D？"
      redirect_to homework_path(@homework)
    end
  end

  def update
    if current_user.is_member_of?(@homework)
      @answer = @homework.answers.find(params[:id])
      if @answer.update(answer_params)
        begin
          if @answer.attachment.file.exists?
            upload_to_google_drive(@answer)
          end
        rescue
          flash[:alert] = "上傳到雖然更改檔案成功，但是上傳失敗，可以再試一次嗎？"
          render :edit
        else
          UserMailer.notify_submit(current_user, @answer, root_url).deliver_later! 	 	
          redirect_to homework_path(@homework), notice: "更新完成"
        end
      else
        flash[:alert] = "是不是有什麼東西少填了，或者檔案超過50MB？"
        render :edit
      end
    else
      flash[:alert] = "不要偷偷更新別人的作業 >///<"
      redirect_to homework_path(@homework)
    end
  end

  def show
    @answer = Answer.find(params[:id])
    if is_admin?(current_user)
      @review = @answer.review
      if @answer.review == nil
        @review = @answer.build_review
      end
    elsif current_user != @answer.author
      redirect_to homework_path(@homework), alert: "不要偷看別人的作業>//<"
    end
  end

  def destroy
    if current_user.is_member_of?(@homework)
      current_user.quit!(@homework)
      @answer = @homework.answers.find(params[:id])
      @answer.destroy
      redirect_to homework_path(@homework), notice: "安全讓作業下架囉!"
    else
      redirect_to homework_path(@homework), alert: "沒有作業是想刪除什麼呢？"
    end
  end

private
  
  def join(homework)
    if !current_user.is_member_of?(homework)
      current_user.join!(homework)
      flash[:notice] = "繳交作業成功！"
    else
      flash[:alert] = "你已經繳交作業了！"
    end
  end
  
  def find_homework
    @homework = Homework.find(params[:homework_id])
    if is_admin?(current_user)
      return
    elsif !can_submit_homework?(current_user, @homework)
      redirect_to homeworks_path, alert: "你應該不是#{@homework.district}的學員XD"
    end
  end

  def answer_params
    params.require(:answer).permit(:title, :description, :attachment)
  end

  def is_admin?(user)
    return current_user && current_user.role == 0
  end
  
  def can_submit_homework?(user, homework)
    if is_admin?(user)
      return false
    elsif user.district == nil
      return true
    elsif user.district == homework.district
      return true
    else
      return false
    end
  end
end

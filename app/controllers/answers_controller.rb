class AnswersController < ApplicationController
  before_action :authenticate_user!  
  
  def index
    @answers = Answer.all
  end
  
  def new
    @homework = Homework.find(params[:homework_id])
    if !current_user.is_member_of?(@homework)
      @answer = @homework.answers.new
    else
      redirect_to homework_path(@homework), alert: "你早就教過作業了喔！"
    end
  end

  def create
    @homework = Homework.find(params[:homework_id])
    if !current_user.is_member_of?(@homework)
      @answer = @homework.answers.build(answer_params)
      if @answer.save
        current_user.join!(@homework) # submit the homework
        redirect_to homework_answer_path(@homework, @answer), notice: "繳交作業成功！"
      else
        render :new
        flash[:alert] = "請檢查是否有哪些地方弄錯，如檔案超過50MB，或者沒有填Title？"
      end
    else
      redirect_to homework_path, alert: "你已經繳交作業了喔：Ｄ"
    end
  end
  
  def edit
  end

  def update
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def destroy
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

  def answer_params
    params.require(:answer).permit(:title, :description, :attachment)
  end
end

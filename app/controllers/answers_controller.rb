class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end
  
  def new
    @homework = Homework.find(params[:homework_id])
    @answer = @homework.answers.new
    puts @answer
  end

  def create
    @homework = Homework.find(params[:homework_id])
    @answer = @homework.answers.build(answer_params)
    if @answer.save 
      redirect_to homework_answer_path(@homework, @answer), notice: "繳交作業成功！"
    else
      flash[:alert] = "請檢查是否有哪些地方弄錯，如檔案超過50MB，或者沒有填Title？"
      render :new 
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
  
  def answer_params
    params.require(:answer).permit(:title, :description, :attachment)
  end
end

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
      redirect_to homework_path(@homework), alert: "你早就交過作業了喔！"
    end
  end

  def create
    @homework = Homework.find(params[:homework_id])
    if !current_user.is_member_of?(@homework)
      @answer = @homework.answers.build(answer_params)
      @answer.author = current_user
      if @answer.save
        current_user.join!(@homework) # submit the homework
        UserMailer.notify_submit(current_user, @answer, root_url).deliver_later! 	 	
        redirect_to homework_path(@homework), notice: "繳交作業成功！"
      else
        flash[:alert] = "請檢查是否有哪些地方弄錯，如檔案超過50MB，或者沒有填Title？"
        render :new
      end
    else
      redirect_to homework_path(@homework), alert: "你已經繳交作業了喔：Ｄ"
    end
  end
  
  def edit
    @homework = Homework.find(params[:homework_id])
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
    @homework = Homework.find(params[:homework_id])
    if current_user.is_member_of?(@homework)
      @answer = @homework.answers.find(params[:id])
      if @answer.update(answer_params)
        UserMailer.notify_submit(current_user, @answer, root_url).deliver_later! 	 	
        redirect_to homework_path(@homework), notice: "更新完成"
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
    @homework = Homework.find(params[:homework_id])
    @answer = Answer.find(params[:id])
    if is_admin?(current_user)
      @review = @answer.build_review
    elsif current_user != @answer.author
      redirect_to homework_path(@homework), alert: "不要偷看別人的作業>//<"
    end
  end

  def destroy
    @homework = Homework.find(params[:homework_id])
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

  def answer_params
    params.require(:answer).permit(:title, :description, :attachment)
  end

  def is_admin?(user)
    return current_user && current_user.role == 0
  end
end

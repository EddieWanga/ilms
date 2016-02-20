class HomeworksController < ApplicationController
  def index
    @homeworks = Homework.all	
  end

  def new
    @homework = Homework.new
  end

  def create
    @homework = Homework.create(homework_params)
    if @homework.save
      redirect_to homework_path(@homework.id)
    else
      render :new
    end
  end
  
  def show
    @homework = Homework.find(params[:id])
    @answers = @homework.answers
  end

  def edit
    @homework = Homework.find(params[:id])
  end
  
  def update
    @homework = Homework.find(params[:id])
    if @homework.update(homework_params)
      redirect_to homework_path(@homework.id)
    else
      render :edit
    end
  end
  
  def destroy
    @homework = Homework.find(params[:id])
    @homework.destroy
    redirect_to homeworks_path, alert: "作業已刪除"
  end

private
  
  def homework_params
    params.require(:homework).permit(:title, :description)
  end  
end

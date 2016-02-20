class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end
  
  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.create(answer_params)
    if @answer.save 
      redirect_to answer_path(@answer)
    else
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

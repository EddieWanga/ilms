class DiscussionsController < ApplicationController
  before_action :authenticate_user!  
  before_action :find_discuss, except: [:index, :new, :create]
  before_action :is_author?, only: [:edit, :update, :destroy]

  def index 
    @discussions  = Discussion.all
  end
  
  def new
    @discussion = Discussion.new
  end

  def create
    @discussion = Discussion.new(dis_params)
    @discussion.email = current_user.email 
    if @discussion.save
      redirect_to discussion_path(@discussion)
    else
      render :new
    end
  end

  def show
  end
  
  def edit
  end

  def update
    if @discussion.update(dis_params)
      redirect_to discussion_path(@discussion)
    else
      render :edit
    end
  end

  def destroy
    @discussion.destroy
    redirect_to discussions_path, alert: "你刪除了一個討論"
  end

private

  def dis_params
    params.require(:discussion).permit(:title, :description)
  end

  def find_discuss
    @discussion = Discussion.find(params[:id])
  end

  def is_author?
    if current_user.email != @discussion.email
      redirect_to discussion_path(@discussion), notice: "你不是發文的人"
    end
  end
end

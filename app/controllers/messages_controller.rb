class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_discuss

  def create
    @message = @discussion.messages.build(message_params)
    @message.author = current_user
    if @message.save
      redirect_to discussion_path(@discussion, :anchor => "message_#{@message.id}"), notice: "你發表了一個回覆"
    else
      redirect_to discussion_path(@discussion, :anchor => "reply"), alert: "請不要什麼都不打"
    end     
  end

  def destroy
    @message = @discussion.messages.find(params[:id])
    if @message.author == current_user
      @message.destroy
      redirect_to discussion_path(@discussion)
    else
      redirect_to discussion_path(@discussion, :anchor => "message_#{@message.id}"), alert: "不要刪別人的回覆"
    end
  end

private
  
  def message_params
    params.require(:message).permit(:description)
  end
   
  def find_discuss
    @discussion = Discussion.find(params[:discussion_id])
  end
end

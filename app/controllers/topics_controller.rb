class TopicsController < ApplicationController
  def welcome
    @topic = Topic.new
  end
  
  def create
    @topic = Topic.new(topic_params)
    user = User.find_by(confirm_code: @topic.confirm_code)
    if user != nil
      user.update(role: 1)
      redirect_to welcome_path, notice: "認證成功！"
    else
      flash[:alert] = "請檢查輸入的驗證碼是否正確"
      render :welcome
    end
  end

private

  def topic_params
    params.require(:topic).permit(:confirm_code)
  end
end

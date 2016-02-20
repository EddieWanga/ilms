class HomeworksController < ApplicationController
  def index
	flash[:notice] = "你還有作業還沒交！"
  end
end

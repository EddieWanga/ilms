class SendEmailJob < ActiveJob::Base
  queue_as :default

  def perform(user, homework, root_url, homework_url)
    @user = user
    @homework = homework
    @root_url = root_url
    @homework_url = homework_url
    UserMailer.notify_new_homework(@user, @homework, @root_url, @homework_url)
  end
end

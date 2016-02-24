class UserMailer < ApplicationMailer
  default from: "sprout@csie.ntu.edu.tw"
  add_template_helper(ApplicationHelper)
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_comment.subject
  #
  def notify_comment
    @greeting = "Hi"
    mail(to: "hkhs7821@gmail.com", subject: "Welcome to sprout!")
  end

  def notify_submit(user, answer, home_url)
    @answer = answer
    @user = user
    @homework = answer.homework
    @url = @answer.attachment.url
    @root_url = home_url.chomp('/')
    mail(to: user.email, subject: "[資訊之芽繳交作業留存] #{@homework.title}")
  end
end

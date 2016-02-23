class UserMailer < ApplicationMailer
  default from: "foy2803@gmail.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_comment.subject
  #
  def notify_comment
    @greeting = "Hi"
    mail(to: "hkhs7821@gmail.com", subject: "Welcome to sprout!")
  end
end

class UserMailer < ApplicationMailer
  default from: "welcome@example.com"

  def welcome_email(user)
    mail(to: user.email, subject: "Welcome To Odin Book!")
  end
end

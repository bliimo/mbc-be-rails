# Preview all emails at http://localhost:3000/rails/mailers/user_notifier_mailer
class UserNotifierMailerPreview < ActionMailer::Preview
  def send_confirmation_email
    UserNotifierMailer.send_confirmation_email(User.first, nil)
  end

  def send_verification_code
    UserNotifierMailer.send_verification_code(User.last, nil)
  end
end

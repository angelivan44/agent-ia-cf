class NotificationMailer < ApplicationMailer
  def notification_email(user_email, message)
    @message = message
    mail(to: user_email, subject: 'Notificación - Comunidad Feliz')
  end
end


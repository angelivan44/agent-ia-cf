class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "noreply@comunidadfeliz.cl")
  layout "mailer"
end

class ApplicationMailer < ActionMailer::Base
  domain = ENV.fetch("HOST_ADDR")
  default from: "admin@#{domain}"
  layout 'mailer'
end

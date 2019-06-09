class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_DEFAULT_FROM']
  layout 'mailer'
end

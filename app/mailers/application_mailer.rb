class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_DEFAULT_FROM'] || 'no-reply@nourish.is'
  layout 'mailer'
end

class MonthlyWorker
  include Sidekiq::Worker

  MAIL_MONTH = 1

  def perform action
    case action
    when MAIL_MONTH
      send_email_when_end_month
    end
  end

  private
  def send_email_when_end_month
    UserMailer.mail_month.deliver
  end
end

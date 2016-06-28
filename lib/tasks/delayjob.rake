namespace :delayjob do
  desc "TODO"
  task mailmonth: :environment do
    MonthlyWorker.perform_async MonthlyWorker::MAIL_MONTH
  end
end

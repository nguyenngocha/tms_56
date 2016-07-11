env :PATH, ENV["PATH"]
set :environment, "development"
set :output, "/home/ngocha/log.log"
every "0 0 0 * *" do
  rake "delayjob:mailmonth"
end

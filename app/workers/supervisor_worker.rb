class SupervisorWorker
  include Sidekiq::Worker

  NOTIFY_FINISH = 1

  def perform action, course_id
    case action
    when NOTIFY_FINISH
      schedule_email_to_notify_course_finish course_id
    end
  end

  private
  def schedule_email_to_notify_course_finish course_id
    course = Course.find_by id: course_id
    UserMailer.will_finish_in_two_days(course).deliver
  end
end

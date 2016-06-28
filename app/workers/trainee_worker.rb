class TraineeWorker
  include Sidekiq::Worker

  ASSIGN_TRAINEE = 1
  DELETE_TRAINEE = 2

  def perform action, trainee_id, course_id
    case action
    when ASSIGN_TRAINEE
      send_email_when_trainee_assigned trainee_id, course_id
    when DELETE_TRAINEE
      send_email_when_trainee_removed trainee_id, course_id
    end
  end

  private
  def send_email_when_trainee_assigned trainee_id, course_id
    trainee = User.find_by id: trainee_id
    course = Course.find_by id: course_id
    UserMailer.assign_to_course(trainee, course).deliver
  end

  def send_email_when_trainee_removed trainee_id, course_id
    trainee = User.find_by id: trainee_id
    course = Course.find_by id: course_id
    UserMailer.delete_from_course(trainee, course).deliver
  end
end
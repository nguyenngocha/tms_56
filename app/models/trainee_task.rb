class TraineeTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :trainee_subject
  belongs_to :task

  enum status: {start: 0, training: 1, finish: 2}

  after_save :create_task_activities
  
  private
  def create_task_activities
    task.create_activity key: I18n.t("activity.finished"), 
      recipient: trainee_subject.course_subject.course
  end
end

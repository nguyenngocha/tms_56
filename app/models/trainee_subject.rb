class TraineeSubject < ActiveRecord::Base
  belongs_to :user
  belongs_to :course_subject
  belongs_to :subject
  belongs_to :user_course

  has_many :trainee_tasks, dependent: :destroy
  has_many :tasks, through: :subject
  
  delegate :content, :description, to: :subject, prefix: true

  enum status: {ready: 0, started: 1, finished: 2}
  
  accepts_nested_attributes_for :trainee_tasks, 
    reject_if: proc{|a| a[:task_id] == "0"}

  def update_status
    task_count = tasks.count
    trainee_task_count = trainee_tasks.count
    if task_count == 0 || trainee_task_count <= 0
      ready!
    else
      if trainee_task_count < task_count
        started!
      elsif trainee_task_count >= task_count
        finished!
        subject.create_activity key: I18n.t("activity.finished"), 
          recipient: user_course.course
      end
    end
  end
end

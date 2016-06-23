class TraineeTask < ActiveRecord::Base
  belongs_to :user
  belongs_to :trainee_subject
  belongs_to :task

  enum status: {start: 0, training: 1, finish: 2}

  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}

  after_save :create_task_activities
  
  private
  def create_task_activities
    create_activity key: I18n.t("activity.finished"), 
      recipient: trainee_subject.course_subject.course
  end
end

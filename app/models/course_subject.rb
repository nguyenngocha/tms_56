class CourseSubject < ActiveRecord::Base
  belongs_to :subject
  belongs_to :course

  has_many :trainee_subjects, dependent: :destroy
  
  delegate :content, :description, to: :subject, prefix: true
  delegate :content, :description, to: :course, prefix: true
  
  enum status: {ready: 0, started: 1, finished: 2}

  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}

  after_create :create_trainee_subject_by_subject
  after_update :create_subject_activity

  private
  def create_trainee_subject_by_subject
    TraineeSubject.transaction do
      begin
        course.user_courses.each do |user_course|
          @trainee_subjects = user_course.trainee_subjects.
            create! user: user_course.user, subject: subject,
            course_subject: self
        end
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end
  
  def create_subject_activity
    if started?
      create_activity key: I18n.t("activity.started"), recipient: course
      course.users.each do |user|
        create_activity key: I18n.t("activity.started"),
          owner: user, recipient: course
      end
    elsif finished?
      create_activity key: I18n.t("activity.finished"), recipient: course
      course.users.each do |user|
        create_activity key: I18n.t("activity.finished"),
          owner: user, recipient: course
      end
    end
  end
end

class Course < ActiveRecord::Base
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects

  belongs_to :user

  accepts_nested_attributes_for :course_subjects,
    reject_if: proc {|attributes| attributes[:subject_id].blank?},
    allow_destroy: true
  accepts_nested_attributes_for :user_courses, allow_destroy: true

  validates :content, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_dates

  enum status: {ready: 0, started: 1, finished: 2}

  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}

  after_create :schedule_mail_to_notify_finish_course
  after_update :create_course_activity

  def build_course_subjects
    Subject.all.each do |subject|
      built = false
      course_subjects.each do |s|
        if s.subject_id == subject.id
          built = true
        end
      end
      self.course_subjects.build subject_id: subject.id unless built == true
    end
  end

  private

  def create_activities type_action
    create_activity key: type_action, recipient: self
    users.each do |user|
      create_activity key: type_action, owner: user, recipient: self
    end
  end

  def create_course_activity
    if started?
      create_activities I18n.t("activity.started")
    elsif finished?
      create_activities I18n.t("activity.finished")
    end
  end

  def valid_dates
    if start_date > end_date
      errors.add :deadline, I18n.t("shared.not_valid_deadline")
    end
  end

  def schedule_mail_to_notify_finish_course
    SupervisorWorker.perform_at (end_date - 2.days), SupervisorWorker::NOTIFY_FINISH, self.id
  end
end

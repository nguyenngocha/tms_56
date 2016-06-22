class CourseSubject < ActiveRecord::Base
  belongs_to :subject
  belongs_to :course

  has_many :trainee_subjects, dependent: :destroy
  
  delegate :content, :description, to: :subject, prefix: true
  delegate :content, :description, to: :course, prefix: true
  
  enum status: {ready: 0, training: 1, finish: 2}

  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}

  after_update :activity
  def activity
    if training?
      create_activity key: I18n.t("activity.subject.started"), recipient: course
      course.users.each do |user|
        create_activity key: I18n.t("activity.subject.started"), owner: user, recipient: course
      end
    elsif finish?
      create_activity key: I18n.t("activity.subject.finished"), recipient: course
      course.users.each do |user|
        create_activity key: I18n.t("activity.subject.finished"), owner: user, recipient: course
      end
    end
  end
end

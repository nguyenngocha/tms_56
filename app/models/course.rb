class Course < ActiveRecord::Base
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects
  
  accepts_nested_attributes_for :course_subjects,
    reject_if: proc {|attributes| attributes[:subject_id].blank?},
    allow_destroy: true
  accepts_nested_attributes_for :user_courses, allow_destroy: true

  validates :content, presence: true

  enum status: {ready: 0, started: 1, finished: 2}

  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}
  
  after_update :activity

  def activity
    if started?
      create_activity key: I18n.t("activity.started"), recipient: self
      users.each do |user|
        create_activity key: I18n.t("activity.started"), owner: user
      end
    elsif finished?
      create_activity key: I18n.t("activity.finished"), recipient: self
      users.each do |user|
        create_activity key: I18n.t("activity.finished"), owner: user
      end
    end
  end
end

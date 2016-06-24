class Subject < ActiveRecord::Base
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects
  has_many :tasks, dependent: :destroy
  has_many :trainee_subjects, dependent: :destroy

  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}
end

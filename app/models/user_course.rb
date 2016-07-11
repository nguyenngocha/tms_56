class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  has_many :trainee_subjects, dependent: :destroy

  enum status: {ready: 0, started: 1, finished: 2}

  scope :load_course, ->course{find_by course_id: course}

  after_save :create_trainee_subject
  after_create :send_mail_assign
  before_destroy :send_mail_delete

  def update_status
    subject_count = course.subjects.count
    finished_subject_count = trainee_subjects.
      select {|ts| ts.finished?}.count
    if subject_count == 0 || finished_subject_count <= 0
      self.update_columns status: 0
    elsif finished_subject_count < subject_count
      self.update_columns status: 1
    else
      self.update_columns status: 2
    end
  end

  private
  def send_mail_assign
    TraineeWorker.perform_async TraineeWorker::ASSIGN_TRAINEE,
      self.user_id, self.course_id
  end

  def send_mail_delete
    TraineeWorker.perform_async TraineeWorker::DELETE_TRAINEE,
      self.user_id, self.course_id
  end

  def create_trainee_subject
    if self.course.course_subjects.any?
      TraineeSubject.transaction do
        begin
          self.course.course_subjects.each do |course_subject|
            course_subject.trainee_subjects.create user: self.user,
              subject: course_subject.subject,
              user_course: self
          end
        rescue
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end

PublicActivity::Activity.class_eval do
  scope :course, -> (course_id) {where(recipient_id: course_id,
    recipient_type: Settings.activity.course)}
  scope :user, -> (user_id) {where(owner_id: user_id, owner_type: "User")}
  scope :task, -> (task_id) {where(trackable_type: "Task", trackable_id: task_id)}
  scope :course_subject -> (course_subject_id) {where(trackable_type: "CourseSubject", trackable_id: course_subject_id)}
end

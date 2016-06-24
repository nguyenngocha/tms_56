PublicActivity::Activity.class_eval do
  scope :course, -> (course_id) {where(recipient_id: course_id,
    recipient_type: Settings.activity.course)}
  scope :user, -> (user_id) {where(owner_id: user_id, owner_type: Settings.activity.user)}
  scope :subject, -> (subject_id) {where(
    trackable_type: Settings.activity.subject, trackable_id: subject_id)}
  scope :by_day, -> (day) {where("DATE(created_at) = ?", day)}
  scope :task, -> (task_id) {where(trackable_type: Settings.activity.task, trackable_id: task_id)}
end

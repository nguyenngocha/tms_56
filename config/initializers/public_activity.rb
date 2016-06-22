PublicActivity::Activity.class_eval do
  scope :course, -> (course_id) {where(recipient_id: course_id,
    recipient_type: Settings.activity.course)}

  scope :user, -> (user_id) {where(owner_id: user_id, owner_type: "User")}
end

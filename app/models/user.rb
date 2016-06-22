class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true, length: {maximum: 50}

  has_many :activities, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :trainee_tasks, dependent: :destroy
  has_many :tasks, through: :trainee_tasks
  has_many :trainee_subjects, dependent: :destroy
  has_many :subjects, through: :trainee_subjects

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  enum role: {trainee: 0, supervisor: 1}

  scope :not_add_course, ->course_id {where "id not in (select user_id
    from user_courses where course_id = ?)", course_id}

  after_destroy :destroy_activities

  include PublicActivity::Model
  tracked

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end
  
  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  def password_required?
    new_record? ? super : false
  end

  def destroy_activities
    PublicActivity::Activity.user(self).each do |activity|
      activity.destroy!
    end 
  end
end

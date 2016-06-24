class Task < ActiveRecord::Base
  belongs_to :subject

  has_many :trainee_tasks, dependent: :destroy
  
  include PublicActivity::Model
  tracked owner: Proc.new{|controller, model| controller.current_user}
end

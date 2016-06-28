class SubjectForm < Reform::Form
  include Reform::Form::ActiveModel
  include Reform::Form::ModelReflections

  model :subject, on: :subject
  
  property :content
  property :description
  
  validates :content, presence: true
  validates :description, presence: true

  collection :tasks, populate_if_empty: Task do
    property :id, writeable: false
    property :content
    property :description
    property :_destroy, writeable: false
  end

  validate :validate_subject_content
  
  def validate_subject_content
    tasks.each do |task|
      if Task.find_by_id(task.id).present? && task.content.blank?
        errors.add :task, I18n.t("task.existing_task_cant_be_blank")
      end
    end
  end

  def save
    super do |attrs|
      destroy = ->(i) {i[:_destroy] == "1"}
      task_ids_to_rm = attrs[:tasks].select(&destroy).map {|i| i[:_destroy]}
      tasks.reject! {|i| task_ids_to_rm.include? i._destroy}
      if model.persisted?
        task_ids_to_rm = attrs[:tasks].select(&destroy).map {|i| i[:id]}
        if task_ids_to_rm.any?
          Task.destroy task_ids_to_rm
        end
        tasks.reject! {|i| task_ids_to_rm.include? i.id}
      end
      tasks.reject! {|i| i.content.blank? && i.description.blank?}
    end
    super
  end
end

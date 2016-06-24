module ApplicationHelper
  def full_title page_title = ""
    base_title = t :base_title
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def current_user? user
    user == current_user
  end

  def link_to_add_fields name, f, association
    new_object = f.object.model.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for association, new_object, child_index: id do |builder|
      render "supervisor/subjects/#{association.to_s.singularize + "_fields"}", f: builder
    end
    link_to name, "#", class: "add_fields",
      data: {id: id, fields: fields.gsub("\n", "")}
  end
end

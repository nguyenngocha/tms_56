class Supervisor::AddUserCoursesController < ApplicationController
  load_and_authorize_resource :course, class: Course.name

  def edit
    @user_courses = @course.user_courses
    @users_not_in_course = User.not_add_course @course
    @users_in_course = @user_courses.collect {|user_course| user_course.user}
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = t "message.add_new_user_for_course_success"
      redirect_to edit_supervisor_course_add_user_courses_path(@course)
    else
      flash[:danger] = t "message.add_new_user_for_course_unsuccess"
      render :edit
    end
  end

  private
  def course_params
    params.require(:course).permit user_ids: []
  end
end

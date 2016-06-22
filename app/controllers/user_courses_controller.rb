class UserCoursesController < ApplicationController
  load_and_authorize_resource
  
  def index
  end

  def show
    @user_courses = @user_course.course.user_courses.page(params[:page]).
      per Settings.courses.per_page
  	
    type_activity = params[:action_type]
    if type_activity == Settings.activity.my
      @activities = PublicActivity::Activity.user(current_user).course(@user_course.course)
      @bottom = Settings.activity.all
    else
      @activities = PublicActivity::Activity.course(@user_course.course)
      @bottom = Settings.activity.my
    end
    @activities = @activities.page(params[:page]).per Settings.activity.per_page
  end
end

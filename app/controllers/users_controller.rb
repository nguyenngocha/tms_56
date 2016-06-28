class UsersController < ApplicationController
  load_and_authorize_resource
  
  def show
    @activities = PublicActivity::Activity
      .user(@user).by_day(Date.today)
      .page(params[:page]).per Settings.activity.per_page
  end
end

class UserMailer < ApplicationMailer
  default from: Settings.mail_from
 
  def assign_to_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: t("mail.assign", content: course.content)
  end

  def delete_from_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: t("mail.delete", content: course.content)
  end

  def will_finish_in_two_days course
    @course = course
    @user = @course.user
    mail to: @user.email, subject: t("mail.will_finish", content: course.content)
  end

  def mail_month
    Course.all.each do |course|
      @supervisor = course.user
      @trainees = course.users
      @course = course
      mail to: @supervisor.email, subject: t("mail.mail_month", content: @course.content)
    end
  end
end

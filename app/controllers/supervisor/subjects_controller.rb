class Supervisor::SubjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_subject_form, except: [:index, :show, :destroy]

  def index
    @subjects = @subjects.page(params[:page]).per Settings.subjects.per_page
  end

  def show
  end

  def new
    @subject.tasks.build
  end

  def create
    if params[:subject] && params[:subject][:tasks_attributes]
      params[:subject][:tasks_attributes].each do |_, value|
        @subject.tasks.build
      end
    end
    if @subject_form.validate params[:subject].permit!
      @subject_form.save
      flash[:success] = t "subject.add_success"
      redirect_to supervisor_subjects_path
    else
      flash.now[:danger] = t "subject.add_fail"
      render :new
    end
  end

  def edit
  end

  def update
    if @subject_form.validate params[:subject].permit!
      @subject_form.save
      flash[:success] = t "subject.edit_success"
      redirect_to supervisor_subjects_path
    else
      flash.now[:danger] = t "subject.edit_fail"
      render :edit
    end
  end
  
  def destroy
    if @subject.destroy
      flash[:success] = t "subject.destroy_success"
    else
      flash[:danger] = t "subject.destroy_fail"
    end
    redirect_to supervisor_subjects_path
  end

  private
  def subject_params
    params.require(:subject).permit :content, :description
  end

  def load_subject_form
    if params[:id]
      @subject_form = SubjectForm.new Subject.find params[:id]
    else
      @subject_form = SubjectForm.new Subject.new
    end
  end
end

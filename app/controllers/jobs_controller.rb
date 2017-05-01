class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :validate_search_key, only: [:search]
  def index
    @jobs = case params[:order]
      when 'by_lower_bound'
        Job.published.order("wage_lower_bound DESC").paginate(:page => params[:page], :per_page => 5)
      when 'by_upper_bound'
        Job.published.order("wage_upper_bound DESC").paginate(:page => params[:page], :per_page => 5)
      else
        Job.published.recent.paginate(:page => params[:page], :per_page => 5)
      end
  end

  def new
    @job = Job.new
  end

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      redirect_to root_path, alert: "This job already archieved"
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, alert: "Job deleted"
  end

  def search
    if @query_string.present? && !@query_string.blank?
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.paginate(:page => params[:page], :per_page => 5)
      if @jobs.blank?
        redirect_to root_path, alert: "没有找到相关工作信息!"
      end
    else
      redirect_to root_path, notice: "搜索信息不能为空，请输入关键字搜索!"
    end
  end

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end

  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :company, :education_background, :work_experience, :location)
  end

end

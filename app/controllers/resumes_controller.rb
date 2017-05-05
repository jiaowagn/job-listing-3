class ResumesController < ApplicationController
  before_action :authenticate_user!
  def new
    @job = Job.find(params[:job_id])
    @resume = Resume.new
    if current_user.has_applied?(@job)
      redirect_to jobs_path, notice: "你已经申请过这个职位"
    end 
  end

  def create
    @job = Job.find(params[:job_id])
    @resume = Resume.new(resume_params)
    @resume.job = @job
    @resume.user = current_user
    if @resume.save
      current_user.apply!(@job)
      redirect_to job_path(@job), notice: "成功提交履历"
    else
      render :new
    end
  end

  private

  def resume_params
    params.require(:resume).permit(:content, :attachment)
  end

end

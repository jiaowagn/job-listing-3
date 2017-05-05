class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :resumes
  has_many :job_relationships
  has_many :applied_jobs, :through => :job_relationships, :source => :job

  def admin?
    is_admin
  end

  def has_applied?(job)
    applied_jobs.include?(job)
  end

  def apply!(job)
    applied_jobs << job
  end

  def display_name
    if self.user_name.present?
      self.user_name
    else
      self.email.split("@").first
    end
  end

  mount_uploader :avatar, AvatarUploader

end

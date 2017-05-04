class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :resumes
  def admin?
    is_admin
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

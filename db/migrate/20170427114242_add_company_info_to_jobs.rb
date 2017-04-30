class AddCompanyInfoToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :company, :string;
    add_column :jobs, :location, :string;
    add_column :jobs, :education_background, :string;
    add_column :jobs, :work_experience, :string;
  end
end

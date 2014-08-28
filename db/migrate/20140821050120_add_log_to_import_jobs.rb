class AddLogToImportJobs < ActiveRecord::Migration
  def change
    add_column :import_jobs, :log, :text
  end  
end

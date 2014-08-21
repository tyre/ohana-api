class ChangeImportJobs < ActiveRecord::Migration
  def change
    add_column :import_jobs, :aasm_state, :string, default: 'new_job'
    
    create_table :import_jobs_organizations, id: false do |t|
      t.integer :import_job_id
      t.integer :organization_id
    end
    add_index :import_jobs_organizations, [ :import_job_id, :organization_id ], unique: true, name: 'index_import_jobs_organizations'
    
  end
end

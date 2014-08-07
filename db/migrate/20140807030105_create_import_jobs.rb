class CreateImportJobs < ActiveRecord::Migration
  def change
    create_table :import_jobs do |t|
    	t.integer :admin_id
    	t.text :url
    	t.timestamps
    end
    add_index :import_jobs, :admin_id
  end
end

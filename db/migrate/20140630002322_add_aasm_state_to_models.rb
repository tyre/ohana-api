class AddAasmStateToModels < ActiveRecord::Migration
  def change
    [ :addresses, :contacts, :faxes, :locations, :mail_addresses, :organizations, :phones, :services ].each do |table|
      add_column table, :aasm_state, :string, null: false, default: 'record_invalid'
      add_column table, :aasm_state_notes, :text
      add_column table, :aasm_state_errors, :text
      add_index table, :aasm_state
      
      add_column table, :deleted_at, :datetime
      add_index table, :deleted_at
    end
    
    reversible do |dir|
      dir.up do
        [ Address, Contact, Fax, MailAddress, Phone, Service, Location, Organization ].each do |model_class|
          puts "Updating validation state for all #{model_class.model_name.human} records..."
          model_class.find_each do |obj|
            obj.updated_at = Time.now.utc
            obj.save!(validate: false)
          end
        end
      end
    end    
  end
end

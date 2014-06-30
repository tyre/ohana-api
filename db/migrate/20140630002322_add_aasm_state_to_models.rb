class AddAasmStateToModels < ActiveRecord::Migration
  def change
    [ :addresses, :contacts, :faxes, :locations, :mail_addresses, :organizations, :phones, :services ].each do |table|
      add_column table, :aasm_state, :string, null: false, default: 'record_invalid'
      add_column table, :aasm_state_notes, :text
      add_column table, :aasm_state_errors, :text
      add_index table, :aasm_state
    end
  end
end

require 'rails_helper'

feature 'Delete location' do
  background do
    skip "Broken"
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when submitting warning', :js do
    find_link('Permanently delete this location').click
    find_link('I understand the consequences, delete this location').click
    expect(current_path).to eq admin_locations_path
    expect(page).not_to have_link 'VRS Services'
  end

  scenario 'when canceling warning', :js do
    find_link('Permanently delete this location').click
    find_button('Close').click
    visit admin_locations_path
    expect(page).to have_link 'VRS Services'
  end
end

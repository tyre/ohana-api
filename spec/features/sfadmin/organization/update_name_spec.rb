require "rails_helper"

feature "Update name" do
  scenario "with empty organization name" do
    organization = create(:organization)
    login_super_admin
    visit "/sfadmin/organizations/#{organization.slug}/edit"

    fill_in "organization_name", with: ""
    click_button "Update Organization"

    expect(page).to have_content "can't be blank"
  end

  scenario "with valid organization name" do
    organization = create(:organization)
    login_super_admin
    visit "/sfadmin/organizations/#{organization.slug}/edit"

    fill_in "organization_name", with: "Juvenile Sexual Responsibility Program"
    click_button "Update Organization"

    expect(page).to have_content("saved successfully")
    expect(page).to have_content("Juvenile Sexual Responsibility Program")
  end
end

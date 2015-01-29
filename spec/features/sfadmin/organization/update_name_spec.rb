require "rails_helper"

feature "Update name" do
  pending "with empty organization name" do
    organization = create(:organization)
    login_super_admin

    visit "/sfadmin/organizations/#{organization.slug}"
    click_on("edit name")
    fill_in "organization_name", with: ""
    click_button "Save"

    expect(page).to have_content "can't be blank"
  end

  pending "with valid organization name" do
    organization = create(:organization)
    login_super_admin
    new_name = "Juvenile Sexual Responsibility Program"

    visit "/sfadmin/organizations/#{organization.slug}"
    click_on("edit name")
    fill_in "organization_name", with: new_name
    click_button "Save"

    expect(page).to have_content("saved successfully")
    expect(page).to have_content(new_name)
  end
end

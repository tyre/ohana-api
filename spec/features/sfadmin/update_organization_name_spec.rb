require "rails_helper"

feature "Update name", :js do
  pending "with empty organization name" do
    organization = create(:organization)
    login_super_admin

    visit sfadmin_organization_path(organization)
    change_attribute("name", "")

    expect(page).to have_content "can't be blank"
  end

  pending "with valid organization name" do
    organization = create(:organization)
    new_name = "Juvenile Sexual Responsibility Program"
    login_super_admin

    visit sfadmin_organization_path(organization)
    change_attribute("name", new_name)

    expect(page).to have_content(new_name)
    expect(organization.reload.name).to eq new_name
  end
end

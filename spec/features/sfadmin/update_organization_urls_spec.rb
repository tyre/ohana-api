require "rails_helper"

feature "Update urls", :js do
  scenario "adding an invalid URL" do
    organization = create(:organization)
    login_super_admin

    visit sfadmin_organization_path(organization)
    add_url("foobar")

    expect(page).to have_content "is not a valid URL"
  end

  scenario "adding a valid URL" do
    organization = create(:organization)
    url = "http://example.com"
    login_super_admin

    visit sfadmin_organization_path(organization)
    add_url(url)

    organization.reload
    expect(page).to have_content(url)
    expect(organization.urls).to eq [url]
  end

  scenario "removing a URL" do
    original_urls = ["http://example.com", "http://foobar.com"]
    organization = create(:organization, urls: original_urls)
    login_super_admin

    visit sfadmin_organization_path(organization)
    all(".url").last.find("a").click

    expect(page).to_not have_content(original_urls.last)
    expect(page).to have_content(original_urls.first)
  end

  def add_url(url)
    find(".new-url").set(url)
    click_on "Add URL"
    wait_for_ajax
  end
end

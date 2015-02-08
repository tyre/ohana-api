require "rails_helper"

feature "Update urls", :js do
  xscenario "adding an empty URL" do
    organization = create(:organization)
    login_super_admin

    visit sfadmin_organization_path(organization)
    add_url("")

    expect(page).to have_content "can't be blank"
  end

  xscenario "adding a valid URL" do
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
    all('.url').last.find('a').click

    expect(page).to_not have_content(original_urls.last)
    expect(page).to have_content(original_urls.first)
  end

  def add_url(url)
    find(".urls input").set(url)
  end
end
